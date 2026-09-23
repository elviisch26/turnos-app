require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Los valores especificados aquí tienen prioridad sobre los de config/application.rb.

  # En el entorno de desarrollo, el código de la aplicación se recarga ante
  # cada cambio. Esto ralentiza el tiempo de respuesta, pero resulta ideal para
  # el desarrollo, ya que no es necesario reiniciar el servidor web al modificar el código.
  config.enable_reloading = true

  # No cargar el código con eager load al arrancar.
  config.eager_load = false

  # Mostrar informes completos de errores.
  config.consider_all_requests_local = true

  # Habilitar server timing
  config.server_timing = true

  # Habilitar o deshabilitar el caché. Por defecto el caché está deshabilitado.
  # Ejecutar rails dev:cache para alternar el caché.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Almacenar los archivos subidos en el sistema de archivos local (ver config/storage.yml para opciones).
  config.active_storage.service = :local

  # No considerar un error si el mailer no puede enviar.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Imprimir los avisos de deprecación en el logger de Rails.
  config.active_support.deprecation = :log

  # Lanzar excepciones ante deprecaciones no permitidas.
  config.active_support.disallowed_deprecation = :raise

  # Indicar a Active Support qué mensajes de deprecación no permitir.
  config.active_support.disallowed_deprecation_warnings = []

  # Lanzar un error al cargar la página si existen migraciones pendientes.
  config.active_record.migration_error = :page_load

  # Resaltar en los registros el código que generó consultas a la base de datos.
  config.active_record.verbose_query_logs = true

  # Resaltar en los registros el código que encoló trabajos en segundo plano.
  config.active_job.verbose_enqueue_logs = true

  # Suprimir la salida del logger para solicitudes de assets.
  config.assets.quiet = true

  # Lanzar un error ante traducciones faltantes.
  # config.i18n.raise_on_missing_translations = true

  # Anotar la vista renderizada con los nombres de archivo.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Descomentar para permitir el acceso de Action Cable desde cualquier origen.
  # config.action_cable.disable_request_forgery_protection = true

  # Lanzar un error cuando las opciones only/except de un before_action referencian acciones inexistentes
  config.action_controller.raise_on_missing_callback_actions = true
end
