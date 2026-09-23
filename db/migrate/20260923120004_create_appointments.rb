# frozen_string_literal: true

# Crear la tabla de reservas de clientes sobre los slots.
class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.references :slot, null: false, foreign_key: true
      t.string :customer_name, null: false
      t.string :customer_email, null: false
      t.integer :status, null: false, default: 0

      # Generar clave de reserva activa:
      # valer NULL al cancelar (permitir nueva reserva posterior),
      # valer "slot|correo" en otro caso (impedir duplicados activos).
      # Emular índice único parcial (MySQL no admitir cláusula WHERE en índices).
      # Estados: 0 pendiente, 1 confirmada, 2 cancelada.
      t.string :active_booking_key,
               limit: 512,
               as: "IF(`status` = 2, NULL, CONCAT(`slot_id`, '|', `customer_email`))",
               stored: true

      t.timestamps
    end

    # Añadir índice para contar reservas confirmadas por slot.
    add_index :appointments, %i[slot_id status]
    # Añadir índice único para evitar doble reserva activa del mismo correo en el mismo slot.
    add_index :appointments, :active_booking_key, unique: true, name: "index_appointments_on_active_booking_key"
  end
end
