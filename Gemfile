source "https://rubygems.org"

ruby "3.2.11"

# Utilizar Rails desde el repositorio en lugar de la versión publicada: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.0"

# Pipeline de assets original de Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Utilizar mysql como base de datos de Active Record
gem "mysql2", "~> 0.5"

# Utilizar el servidor web Puma [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Utilizar JavaScript con import maps ESM [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Acelerador de páginas tipo SPA de Hotwire [https://turbo.hotwired.dev]
gem "turbo-rails"

# Framework JavaScript ligero de Hotwire [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Crear API JSON con facilidad [https://github.com/rails/jbuilder]
gem "jbuilder"

# Utilizar el adaptador Redis para ejecutar Action Cable en producción
# gem "redis", ">= 4.0.1"

# Utilizar Kredis para obtener tipos de datos de nivel superior en Redis [https://github.com/rails/kredis]
# gem "kredis"

# Utilizar has_secure_password de Active Model [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows no incluye archivos zoneinfo; incluir la gema tzinfo-data
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reducir los tiempos de arranque mediante caché; requerido en config/boot.rb
gem "bootsnap", require: false

# Utilizar variantes de Active Storage [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # Ver https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  # Utilizar consola en las páginas de excepciones [https://github.com/rails/web-console]
  gem "web-console"

  # Agregar insignias de velocidad [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Acelerar comandos en equipos lentos o aplicaciones grandes [https://github.com/rails/spring]
  # gem "spring"

end

group :test do
  # Utilizar pruebas de sistema [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end
