require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Los valores especificados aquí tienen prioridad sobre los de config/application.rb.

  # El código no se recarga entre solicitudes.
  config.enable_reloading = false

  # Cargar el código con eager load al arrancar. Esto carga en memoria la mayor parte de Rails y
  # de la aplicación, permitiendo un mejor rendimiento tanto en servidores web con hilos
  # como en aquellos basados en copy on write.
  # Las tareas Rake ignoran automáticamente esta opción por rendimiento.
  config.eager_load = true

  # Los informes completos de errores están deshabilitados y el caché está activado.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Garantizar la disponibilidad de una clave maestra en ENV["RAILS_MASTER_KEY"], config/master.key o una clave
  # de entorno como config/credentials/production.key. Esta clave se utiliza para descifrar credenciales (y otros archivos cifrados).
  # config.require_master_key = true

  # Habilitar el servicio de archivos estáticos desde la carpeta `/public` (deshabilitar si se utiliza NGINX/Apache para ello).
  config.public_file_server.enabled = true

  # Comprimir CSS mediante un preprocesador.
  # config.assets.css_compressor = :sass

  # No recurrir al pipeline de assets si un asset precompilado no se encuentra.
  config.assets.compile = false

  # Habilitar el servicio de imágenes, hojas de estilo y JavaScript desde un servidor de assets.
  # config.asset_host = "http://assets.example.com"

  # Especificar la cabecera que el servidor utiliza para el envío de archivos.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # para Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # para NGINX

  # Almacenar los archivos subidos en el sistema de archivos local (ver config/storage.yml para opciones).
  config.active_storage.service = :local

  # Montar Action Cable fuera del proceso o dominio principal.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]

  # Asumir que todo el acceso a la aplicación ocurre a través de un proxy inverso con terminación SSL.
  # Puede combinarse con config.force_ssl para Strict-Transport-Security y cookies seguras.
  # config.assume_ssl = true

  # Forzar todo el acceso a la aplicación sobre SSL, utilizar Strict-Transport-Security y usar cookies seguras.
  config.force_ssl = true

  # Registrar en STDOUT por defecto
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # Anteponer las siguientes etiquetas a todas las líneas de registro.
  config.log_tags = [ :request_id ]

  # Info incluye información genérica y útil sobre la operación del sistema, pero evita registrar demasiada
  # información para prevenir la exposición inadvertida de información de identificación personal (PII). Para
  # registrar todo, establecer el nivel en "debug".
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Utilizar otro almacén de caché en producción.
  # config.cache_store = :mem_cache_store

  # Utilizar un backend real de colas para Active Job (y colas separadas por entorno).
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "turnos_app_production"

  config.action_mailer.perform_caching = false

  # Ignorar direcciones de correo inválidas y no lanzar errores de entrega.
  # Establecer en true y configurar el servidor de correo para la entrega inmediata para lanzar errores de entrega.
  # config.action_mailer.raise_delivery_errors = false

  # Habilitar alternativas de locale para I18n (permite que las búsquedas de cualquier locale recurran a
  # I18n.default_locale cuando no se encuentra una traducción).
  config.i18n.fallbacks = true

  # No registrar ninguna deprecación.
  config.active_support.report_deprecations = false

  # No volcar el esquema después de las migraciones.
  config.active_record.dump_schema_after_migration = false

  # Habilitar la protección contra reasociación de DNS y otros ataques de cabecera `Host`.
  # config.hosts = [
  #   "example.com",     # Permitir solicitudes de example.com
  #   /.*\.example\.com/ # Permitir solicitudes de subdominios como `www.example.com`
  # ]
  # Omitir la protección contra reasociación de DNS para el endpoint de salud por defecto.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end
