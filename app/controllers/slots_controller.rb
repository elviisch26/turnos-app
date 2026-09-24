# Listar horarios y mostrar detalle con formularios de reserva y espera.
class SlotsController < ApplicationController
  # Mostrar lista de horarios ordenados.
  def index
    @slots = Slot.includes(service: :business).order(:starts_at)
  end

  # Mostrar un horario con capacidad, reservas y lista de espera.
  def show
    @slot = Slot.find(params[:id])
    @appointment = Appointment.new
    @waitlist_entry = WaitlistEntry.new
  end
end
