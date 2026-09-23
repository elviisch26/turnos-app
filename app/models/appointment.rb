# Representar una reserva de un cliente sobre un slot.
#
# Utilizar Appointment.book! para crear reservas:
# aplicar transacción y bloqueo para evitar sobrerreserva ante concurrencia.
class Appointment < ApplicationRecord
  # Indicar agotamiento de capacidad del slot.
  class SlotFullError < StandardError; end

  # Definir estados posibles: pendiente, confirmada, cancelada.
  enum :status, { pending: 0, confirmed: 1, cancelled: 2 }

  # Definir asociaciones.
  belongs_to :slot

  # Definir alcance de reservas activas (pendientes o confirmadas).
  scope :active, -> { where(status: %i[pending confirmed]) }

  # Validar datos del cliente y unicidad de reserva activa por slot.
  validates :customer_name, presence: { message: "no puede estar en blanco" }
  validates :customer_email, presence: { message: "no puede estar en blanco" }
  validates :customer_email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "no es válido" }
  validates :customer_email, uniqueness: {
    scope: :slot_id,
    conditions: -> { where.not(status: :cancelled) },
    message: "ya posee una reserva activa en este horario"
  }
  validate :capacidad_disponible, if: :confirmed?

  # Crear una reserva aplicando bloqueo del slot para evitar sobrerreserva.
  # Al agotar capacidad, añadir a la lista de espera de forma automática
  # y propagar el error.
  def self.book!(slot:, customer_name:, customer_email:, status: :confirmed)
    slot.with_lock do
      if slot.appointments.confirmed.count >= slot.capacity
        raise SlotFullError, "el slot ya alcanzó su capacidad máxima"
      end

      return create!(
        slot: slot,
        customer_name: customer_name,
        customer_email: customer_email,
        status: status
      )
    end
  rescue SlotFullError
    # Añadir a la lista de espera en una transacción separada y propagar el error.
    WaitlistEntry.enqueue!(slot: slot, customer_name: customer_name, customer_email: customer_email)
    raise
  end

  # Cancelar la reserva y promover la primera entrada de la lista de espera.
  def cancel!
    self.class.transaction do
      slot.with_lock do
        update!(status: :cancelled)

        siguiente = slot.waitlist_entries.order(:position).first
        next if siguiente.blank?

        self.class.create!(
          slot: slot,
          customer_name: siguiente.customer_name,
          customer_email: siguiente.customer_email,
          status: :confirmed
        )
        posicion = siguiente.position
        siguiente.destroy!
        slot.waitlist_entries.where("position > ?", posicion).order(:position).each do |entry|
          entry.decrement!(:position)
        end
      end
    end
  end

  private

  # Verificar que el slot conserve capacidad al confirmar.
  # Nota: validar de forma aislada no impedir sobrerreserva ante concurrencia;
  # utilizar Appointment.book! para aplicar bloqueo.
  def capacidad_disponible
    return if slot.blank?

    ocupadas = slot.appointments.confirmed.where.not(id: id).count
    return if ocupadas < slot.capacity

    errors.add(:slot, "ya alcanzó su capacidad máxima")
  end
end
