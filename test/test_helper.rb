ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Ejecutar las pruebas en paralelo con los workers especificados
    parallelize(workers: :number_of_processors, with: :threads)

    # Configurar todos los fixtures en test/fixtures/*.yml para todas las pruebas en orden alfabético.
    fixtures :all

    # Agregar aquí más métodos auxiliares para todas las pruebas...
  end
end
