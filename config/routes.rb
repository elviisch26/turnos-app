Rails.application.routes.draw do
  # Exponer el estado de salud en /up, que responde 200 si la aplicación arranca sin excepciones, o 500 en caso contrario.
  # Permite a balanceadores de carga y monitores de disponibilidad verificar que la aplicación está en funcionamiento.
  get "up" => "rails/health#show", as: :rails_health_check

  # Definir la ruta raíz como lista de servicios.
  root "services#index"

  # Listar servicios y ver detalle con sus horarios.
  resources :services, only: %i[index show]

  # Listar horarios y ver detalle con formulario de reserva.
  resources :slots, only: %i[index show] do
    # Crear reservas y anotaciones en espera anidadas al horario.
    resources :appointments, only: %i[create]
    resources :waitlist_entries, only: %i[create]
  end

  # Cancelar reservas existentes.
  resources :appointments, only: %i[destroy]
end
