# Este archivo es utilizado por los servidores basados en Rack para iniciar la aplicación.

require_relative "config/environment"

run Rails.application
Rails.application.load_server
