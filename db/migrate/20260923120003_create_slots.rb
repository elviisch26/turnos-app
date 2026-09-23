# frozen_string_literal: true

# Crear la tabla de bloques de tiempo disponibles (slots) por servicio.
class CreateSlots < ActiveRecord::Migration[7.1]
  def change
    # Crear tabla con referencia al servicio, inicio, fin y capacidad.
    create_table :slots do |t|
      t.references :service, null: false, foreign_key: true
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.integer :capacity, null: false

      t.timestamps
    end

    # Añadir índice único para evitar slots duplicados por servicio y hora de inicio.
    add_index :slots, %i[service_id starts_at], unique: true
  end
end
