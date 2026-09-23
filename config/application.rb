require_relative "boot"

require "rails/all"

# Requerir las gemas listadas en el Gemfile, incluidas las limitadas
# a :test, :development o :production.
Bundler.require(*Rails.groups)

module TurnosApp
  class Application < Rails::Application
    # Inicializar los valores de configuración por defecto de la versión de Rails generada originalmente.
    config.load_defaults 7.1

    # Agregar a la lista `ignore` cualquier otro subdirectorio de `lib` que no
    # contenga archivos `.rb` o que no deba recargarse ni cargarse con eager load.
    # Ejemplos habituales: `templates`, `generators` o `middleware`.
    config.autoload_lib(ignore: %w(assets tasks))

    # La configuración de la aplicación, los engines y los railties se ubica aquí.
    #
    # Utilizar español neutro como idioma por defecto
    # (identificadores en inglés por convención Rails,
    # mensajes y comentarios en español neutro impersonal).
    config.i18n.default_locale = :es
    #
    # Estos valores pueden sobrescribirse en entornos específicos mediante los archivos
    # de config/environments, que se procesan posteriormente.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
