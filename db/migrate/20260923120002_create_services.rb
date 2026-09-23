# frozen_string_literal: true

# Crear la tabla de servicios ofrecidos por cada negocio.
class CreateServices < ActiveRecord::Migration[7.1]
  def change
    # Crear tabla con referencia al negocio, nombre, duración y capacidad.
    create_table :services do |t|
      t.references :business, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :duration_min, null: false
      t.integer :capacity, null: false, default: 1

      t.timestamps
    end

    # Añadir índice único para evitar servicios duplicados dentro del mismo negocio.
    add_index :services, %i[business_id name], unique: true
  end
end
