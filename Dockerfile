# syntax = docker/dockerfile:1

# Verificar que RUBY_VERSION coincida con la versión de Ruby en .ruby-version y Gemfile
ARG RUBY_VERSION=3.2.11
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# La aplicación Rails reside en este directorio
WORKDIR /rails

# Establecer el entorno de producción
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"


# Etapa de compilación desechable para reducir el tamaño de la imagen final
FROM base as build

# Instalar los paquetes necesarios para compilar las gemas
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential default-libmysqlclient-dev git libvips pkg-config

# Instalar las gemas de la aplicación
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copiar el código de la aplicación
COPY . .

# Precompilar el código de bootsnap para tiempos de arranque más rápidos
RUN bundle exec bootsnap precompile app/ lib/

# Ajustar los binarios para que sean ejecutables en Linux
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

# Precompilar los assets para producción sin requerir la clave secreta RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# Etapa final de la imagen de la aplicación
FROM base

# Instalar los paquetes necesarios para el despliegue
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl default-mysql-client libvips && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copiar los artefactos compilados: gemas, aplicación
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Ejecutar y asignar solo los archivos de runtime a un usuario sin privilegios por seguridad
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# El punto de entrada prepara la base de datos.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Iniciar el servidor por defecto; es posible sobrescribir este valor en runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
