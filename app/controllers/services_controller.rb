# Listar servicios y mostrar detalle con horarios.
class ServicesController < ApplicationController
  # Mostrar lista de servicios.
  def index
    @services = Service.includes(:business, :slots).order(:name)
  end

  # Mostrar un servicio con sus horarios ordenados.
  def show
    @service = Service.find(params[:id])
    @slots = @service.slots.order(:starts_at)
  end
end
