# Crear anotaciones en lista de espera de un horario.
class WaitlistEntriesController < ApplicationController
  # Añadir un cliente al final de la lista con WaitlistEntry.enqueue!.
  def create
    @slot = Slot.find(params[:slot_id])
    @waitlist_entry = WaitlistEntry.enqueue!(
      slot: @slot,
      customer_name: waitlist_params[:customer_name],
      customer_email: waitlist_params[:customer_email]
    )

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to slot_path(@slot), notice: "Anotación en lista de espera registrada." }
    end
  rescue ActiveRecord::RecordInvalid => error
    @appointment = Appointment.new
    @waitlist_entry = error.record
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

  private

  # Permitir solo nombre y correo desde el formulario.
  def waitlist_params
    params.require(:waitlist_entry).permit(:customer_name, :customer_email)
  end
end
