# Este archivo de configuración es evaluado por Puma. Los métodos de nivel superior
# invocados aquí forman parte del DSL de configuración de Puma. Para más información
# sobre los métodos del DSL, ver https://puma.io/puma/Puma/DSL.html.

# Puma atiende cada solicitud en un hilo de un pool interno de hilos.
# El método `threads` recibe dos números: mínimo y máximo.
# Las bibliotecas que utilizan pools de hilos deben configurarse con el mismo
# valor máximo especificado para Puma. Por defecto se establecen 5 hilos como mínimo
# y máximo; este valor coincide con el tamaño de hilos por defecto de Active Record.
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Especificar que la cantidad de workers debe igualar la cantidad de procesadores en producción.
if ENV["RAILS_ENV"] == "production"
  require "concurrent-ruby"
  worker_count = Integer(ENV.fetch("WEB_CONCURRENCY") { Concurrent.physical_processor_count })
  workers worker_count if worker_count > 1
end

# Especificar el umbral `worker_timeout` que Puma utiliza antes de
# finalizar un worker en entornos de desarrollo.
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Especificar el `port` en el que Puma recibe las solicitudes; por defecto es 3000.
port ENV.fetch("PORT") { 3000 }

# Especificar el `environment` en el que se ejecuta Puma.
environment ENV.fetch("RAILS_ENV") { "development" }

# Especificar el `pidfile` que utiliza Puma.
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Permitir reiniciar Puma con el comando `bin/rails restart`.
plugin :tmp_restart
