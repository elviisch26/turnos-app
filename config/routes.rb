Rails.application.routes.draw do
  # Definir las rutas de la aplicación según el DSL en https://guides.rubyonrails.org/routing.html

  # Exponer el estado de salud en /up, que responde 200 si la aplicación arranca sin excepciones, o 500 en caso contrario.
  # Permite a balanceadores de carga y monitores de disponibilidad verificar que la aplicación está en funcionamiento.
  get "up" => "rails/health#show", as: :rails_health_check

  # Definir la ruta raíz ("/")
  # root "posts#index"
end
