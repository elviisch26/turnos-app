# Crear y cancelar reservas aplicando control de concurrencia del modelo.
class AppointmentsController < ApplicationController
  # Crear una reserva con Appointment.book! para evitar sobrerreserva.
  # Si el servicio elegido difiere del horario actual, asignar el próximo
  # horario libre de ese servicio y redirigir ahí con aviso.
  def create
    @slot = Slot.find(params[:slot_id])
    servicio = servicio_seleccionado(@slot)

    if servicio.id == @slot.service_id
      asignacion_automatica = false
    else
      @slot = Slot.next_available_for(servicio)
      if @slot.nil?
        redirect_to service_path(servicio),
                    alert: "No hay horarios libres para #{servicio.name}."
        return
      end
      asignacion_automatica = true
    end

    @appointment = Appointment.book!(
      slot: @slot,
      customer_name: appointment_params[:customer_name],
      customer_email: appointment_params[:customer_email]
    )

    if asignacion_automatica
      redirect_to slot_path(@slot),
                  notice: "Te asignamos un horario de #{@slot.service.name}: #{I18n.l(@slot.starts_at, format: :short)}."
    else
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to slot_path(@slot), notice: "Reserva creada correctamente." }
      end
    end
  rescue Appointment::SlotFullError
    # Redirigir al horario con aviso para anotarse en espera.
    respond_to do |format|
      format.turbo_stream do
        flash.now[:alert] = "El horario está completo. Anotarse en la lista de espera."
        render :slot_full, status: :unprocessable_entity
      end
      format.html do
        redirect_to slot_path(@slot),
                    alert: "El horario está completo. Anotarse en la lista de espera."
      end
    end
  rescue ActiveRecord::RecordInvalid => error
    # Reintentar mostrar el horario con errores de validación.
    @waitlist_entry = WaitlistEntry.new
    @appointment = error.record
    respond_to do |format|
      format.turbo_stream do
        render :create_error, status: :unprocessable_entity
      end
      format.html do
        flash.now[:alert] = "Revisar los datos del formulario."
        render "slots/show", status: :unprocessable_entity
      end
    end
  end

  # Cancelar una reserva y liberar capacidad.
  def destroy
    @appointment = Appointment.find(params[:id])
    @slot = @appointment.slot
    @appointment.cancel!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to slot_path(@slot), notice: "Reserva cancelada correctamente." }
    end
  end

  private

  # Permitir solo nombre y correo desde el formulario.
  def appointment_params
    params.require(:appointment).permit(:customer_name, :customer_email)
  end

  # Servicio elegido en el formulario; por defecto, el del horario actual.
  def servicio_seleccionado(slot_actual)
    id = params[:service_id].presence
    return slot_actual.service if id.blank?

    Service.find(id)
  end
end
