# Representar una entrada en la lista de espera de un slot.
class WaitlistEntry < ApplicationRecord
  # Definir asociaciones.
  belongs_to :slot

  # Validar datos del cliente y unicidad dentro de la lista del slot.
  validates :customer_name, presence: { message: "no puede estar en blanco" }
  validates :customer_email, presence: { message: "no puede estar en blanco" }
  validates :customer_email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "no es válido" }
  validates :customer_email, uniqueness: {
    scope: :slot_id,
    message: "ya se encuentra en la lista de espera de este horario"
  }
  validates :position,
            presence: { message: "no puede estar en blanco" },
            numericality: { only_integer: true, greater_than_or_equal_to: 1, message: "debe ser mayor o igual que 1" }

  # Añadir un cliente al final de la lista aplicando bloqueo del slot
  # para evitar posiciones duplicadas ante concurrencia.
  def self.enqueue!(slot:, customer_name:, customer_email:)
    slot.with_lock do
      ultima = where(slot_id: slot.id).maximum(:position).to_i
      create!(
        slot: slot,
        customer_name: customer_name,
        customer_email: customer_email,
        position: ultima + 1
      )
    end
  end
end
