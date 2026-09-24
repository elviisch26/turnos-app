# Representar un bloque de tiempo disponible para un servicio.
class Slot < ApplicationRecord
  # Definir asociaciones.
  belongs_to :service
  has_many :appointments, dependent: :destroy
  has_many :waitlist_entries, dependent: :destroy

  # Validar atributos y coherencia temporal.
  validates :starts_at, presence: { message: "no puede estar en blanco" }
  validates :starts_at, uniqueness: { scope: :service_id, message: "ya se encuentra registrado para este servicio" }
  validates :ends_at, presence: { message: "no puede estar en blanco" }
  validates :capacity,
            presence: { message: "no puede estar en blanco" },
            numericality: { only_integer: true, greater_than_or_equal_to: 1, message: "debe ser mayor o igual que 1" }
  validate :fin_posterior_al_inicio

  # Contar reservas confirmadas del slot.
  def confirmed_count
    appointments.confirmed.count
  end

  # Calcular lugares libres del slot.
  def remaining_capacity
    capacity - confirmed_count
  end

  # Indicar si el slot alcanzó su capacidad.
  def full?
    remaining_capacity <= 0
  end

  # Buscar el próximo horario futuro del servicio con capacidad restante.
  def self.next_available_for(service)
    service.slots.where("starts_at > ?", Time.current).order(:starts_at).detect { |slot| !slot.full? }
  end

  private

  # Verificar que la hora de fin sea posterior a la hora de inicio.
  def fin_posterior_al_inicio
    return if starts_at.blank? || ends_at.blank?
    return if ends_at > starts_at

    errors.add(:ends_at, "debe ser posterior a la hora de inicio")
  end
end
