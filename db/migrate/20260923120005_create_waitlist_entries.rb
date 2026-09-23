# frozen_string_literal: true

# Crear la tabla de lista de espera por slot.
class CreateWaitlistEntries < ActiveRecord::Migration[7.1]
  def change
    # Crear tabla con referencia al slot, datos del cliente y posición.
    create_table :waitlist_entries do |t|
      t.references :slot, null: false, foreign_key: true
      t.string :customer_name, null: false
      t.string :customer_email, null: false
      t.integer :position, null: false

      t.timestamps
    end

    # Añadir índice único para evitar duplicar un correo en la lista del mismo slot.
    add_index :waitlist_entries, %i[slot_id customer_email],
              unique: true, name: "index_waitlist_on_slot_and_email"
    # Añadir índice único para mantener una posición por lugar en la lista.
    add_index :waitlist_entries, %i[slot_id position],
              unique: true, name: "index_waitlist_on_slot_and_position"
  end
end
