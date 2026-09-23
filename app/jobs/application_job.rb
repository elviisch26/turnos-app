class ApplicationJob < ActiveJob::Base
  # Reintentar automáticamente los trabajos que encontraron un deadlock
  # retry_on ActiveRecord::Deadlocked

  # La mayoría de los trabajos pueden ignorarse si los registros subyacentes ya no están disponibles
  # discard_on ActiveJob::DeserializationError
end
