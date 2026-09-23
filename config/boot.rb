ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Configurar las gemas listadas en el Gemfile.
require "bootsnap/setup" # Acelerar el arranque mediante el almacenamiento en caché de operaciones costosas.
