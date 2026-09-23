# Representar un negocio que ofrece servicios con reserva de turnos.
class Business < ApplicationRecord
  # Definir asociaciones.
  has_many :services, dependent: :destroy

  # Validar presencia y unicidad de atributos obligatorios.
  validates :name, presence: { message: "no puede estar en blanco" }
  validates :name, uniqueness: { message: "ya se encuentra registrado" }
  validates :time_zone, presence: { message: "no puede estar en blanco" }
  validate :time_zone_valido

  private

  # Verificar que la zona horaria sea reconocida por el sistema.
  def time_zone_valido
    return if time_zone.blank?
    return if ActiveSupport::TimeZone[time_zone].present?

    errors.add(:time_zone, "no es válida")
  end
end
