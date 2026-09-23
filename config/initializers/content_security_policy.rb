# Reiniciar el servidor al modificar este archivo.

# Definir una política de seguridad de contenido para toda la aplicación.
# Ver la Guía de Seguridad de Rails para más información:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

# Rails.application.configure do
#   config.content_security_policy do |policy|
#     policy.default_src :self, :https
#     policy.font_src    :self, :https, :data
#     policy.img_src     :self, :https, :data
#     policy.object_src  :none
#     policy.script_src  :self, :https
#     policy.style_src   :self, :https
#     # Especificar el URI para los informes de violaciones
#     # policy.report_uri "/csp-violation-report-endpoint"
#   end
#
#   # Generar nonces de sesión para importmap, scripts inline y estilos inline permitidos.
#   config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
#   config.content_security_policy_nonce_directives = %w(script-src style-src)
#
#   # Informar violaciones sin aplicar la política.
#   # config.content_security_policy_report_only = true
# end
