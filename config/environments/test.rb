require "active_support/core_ext/integer/time"

# El entorno de prueba se utiliza exclusivamente para ejecutar la suite de
# pruebas de la aplicación. No es necesario trabajar con él en otro caso. Tener en cuenta que
# la base de datos de prueba es un espacio temporal para la suite de pruebas y se elimina
# y se recrea entre ejecuciones. No depender de los datos allí almacenados.

Rails.application.configure do
  # Los valores especificados aquí tienen prioridad sobre los de config/application.rb.

  # Durante la ejecución de las pruebas no se observan archivos; la recarga no es necesaria.
  config.enable_reloading = false

  # La carga eager carga la aplicación completa. Al ejecutar una sola prueba en local,
  # esto normalmente no es necesario y puede ralentizar la suite de pruebas. Sin embargo, se
  # recomienda habilitarlo en sistemas de integración continua para verificar que la carga eager
  # funciona correctamente antes de desplegar el código.
  config.eager_load = ENV["CI"].present?

  # Configurar el servidor de archivos públicos para pruebas con Cache-Control por rendimiento.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # Mostrar informes completos de errores y deshabilitar el caché.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Lanzar excepciones en lugar de renderizar plantillas de excepción.
  config.action_dispatch.show_exceptions = :rescuable

  # Deshabilitar la protección contra falsificación de solicitudes en el entorno de prueba.
  config.action_controller.allow_forgery_protection = false

  # Almacenar los archivos subidos en el sistema de archivos local en un directorio temporal.
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # Indicar a Action Mailer que no entregue correos al mundo real.
  # El método de entrega :test acumula los correos enviados en el
  # arreglo ActionMailer::Base.deliveries.
  config.action_mailer.delivery_method = :test

  # Imprimir los avisos de deprecación en stderr.
  config.active_support.deprecation = :stderr

  # Lanzar excepciones ante deprecaciones no permitidas.
  config.active_support.disallowed_deprecation = :raise

  # Indicar a Active Support qué mensajes de deprecación no permitir.
  config.active_support.disallowed_deprecation_warnings = []

  # Lanzar un error ante traducciones faltantes.
  # config.i18n.raise_on_missing_translations = true

  # Anotar la vista renderizada con los nombres de archivo.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Lanzar un error cuando las opciones only/except de un before_action referencian acciones inexistentes
  config.action_controller.raise_on_missing_callback_actions = true
end
