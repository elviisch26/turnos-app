# Representar un servicio ofrecido por un negocio (ej.: corte, consulta).
class Service < ApplicationRecord
  # Definir asociaciones.
  belongs_to :business
  has_many :slots, dependent: :destroy

  # Validar atributos obligatorios y rangos permitidos.
  validates :name, presence: { message: "no puede estar en blanco" }
  validates :name, uniqueness: { scope: :business_id, message: "ya se encuentra registrado en este negocio" }
  validates :duration_min,
            presence: { message: "no puede estar en blanco" },
            numericality: { only_integer: true, greater_than: 0, message: "debe ser mayor que 0" }
  validates :capacity,
            presence: { message: "no puede estar en blanco" },
            numericality: { only_integer: true, greater_than_or_equal_to: 1, message: "debe ser mayor o igual que 1" }
end
