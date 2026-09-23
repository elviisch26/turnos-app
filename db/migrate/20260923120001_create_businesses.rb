# frozen_string_literal: true

# Crear la tabla de negocios.
class CreateBusinesses < ActiveRecord::Migration[7.1]
  def change
    # Crear tabla con nombre y zona horaria.
    create_table :businesses do |t|
      t.string :name, null: false
      t.string :time_zone, null: false

      t.timestamps
    end

    # Añadir índice único para evitar negocios duplicados.
    add_index :businesses, :name, unique: true
  end
end
