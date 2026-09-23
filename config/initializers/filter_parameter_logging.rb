# Reiniciar el servidor al modificar este archivo.

# Configurar los parámetros con coincidencia parcial (p. ej., passw coincide con password) para filtrarlos del archivo de registro.
# Utilizar esta opción para limitar la difusión de información sensible.
# Ver la documentación de ActiveSupport::ParameterFilter para notaciones y comportamientos admitidos.
Rails.application.config.filter_parameters += [
  :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn
]
