# TurnosApp

Aplicación de reservas de turnos para **Peluquería Central**. Los visitantes eligen un
servicio, reservan un horario con nombre y correo, pueden anotarse en lista de espera
cuando un horario está completo y cancelar reservas (la primera entrada en espera se
promueve automáticamente).

## Stack

- Ruby 3.2.11 · Rails 7.1.6 · MySQL (gema `mysql2`) · Puma 8
- Hotwire (Turbo) + importmap, sin Node
- Tailwind CSS v4 vía `tailwindcss-rails` (CLI independiente)

## Requisitos

- Ruby 3.2 + Bundler
- MySQL en marcha con usuario `root` y contraseña `turnos-app`
  (ver `config/database.yml`; ajustar ahí si tu entorno difiere)

## Puesta en marcha

```powershell
bundle install
bin\rails db:create db:schema:load db:seed
ruby bin\rails server
```

Esperar ~15-20 segundos hasta `Listening on http://127.0.0.1:3000` y abrir
`http://localhost:3000`.

Notas:

- En una base ya existente, `db:schema:load` falla por el orden de borrado de claves
  foráneas en MySQL (`Cannot drop table 'businesses' ...`). Para un reseteo limpio usar
  `db:drop db:create db:schema:load db:seed`.
- `db:seed` crea el negocio, 2 servicios (Corte de cabello cap. 3, Arreglo de barba
  cap. 4) y 5 horarios a partir de mañana 9:00. Es idempotente salvo por fechas: si los
  horarios semilla quedan en el pasado, volver a correr el seed genera tandas nuevas.

## Desarrollo

```powershell
# Recompilar el CSS de Tailwind una vez
bundle exec rails tailwindcss:build

# Observar cambios de CSS en otra terminal
bundle exec rails tailwindcss:watch

# Correr pruebas
bundle exec rails test
```

Notas de Windows:

- El plugin `tmp_restart` de Puma está desactivado en Windows (`config/puma.rb`):
  provocaba un reinicio en bucle al arrancar. Para reiniciar, detener con Ctrl+C y
  volver a levantar.
- Para probar HTTP desde PowerShell usar `curl.exe`; `Invoke-WebRequest` falla contra
  localhost por la configuración de proxy.

## Funcionalidad

- **Servicios** (`/services`): grilla de tarjetas con duración; detalle con sus horarios
  y capacidad restante.
- **Horarios** (`/slots`): lista con capacidad restante y marca de completo; detalle con
  capacidad, formulario de reserva, lista de espera, confirmadas y en espera.
- **Reserva con selector de servicio**: el formulario incluye nombre, correo y servicio.
  Si el servicio elegido es el del horario, se reserva ahí. Si es otro, el sistema
  asigna automáticamente el próximo horario futuro con lugar de ese servicio y redirige
  ahí con aviso ("Te asignamos un horario de ..."). Sin horarios libres, redirige al
  servicio con alerta.
- **Concurrencia**: `Appointment.book!` reserva con bloqueo de fila; si el horario se
  completa en carrera, anota en espera y propaga `SlotFullError`.
- **Cancelación**: libera capacidad y promueve la primera entrada de la lista de espera.
- **Reglas**: correo válido obligatorio; sin doble reserva activa del mismo correo por
  horario (índice único `active_booking_key`); capacidad mínima 1 en servicios y horarios.

## Rutas principales

| Método | Ruta | Acción |
| ------ | ---- | ------ |
| GET | `/`, `/services`, `/services/:id` | Servicios |
| GET | `/slots`, `/slots/:id` | Horarios |
| POST | `/slots/:slot_id/appointments` | Reservar (`service_id`, nombre, correo) |
| DELETE | `/appointments/:id` | Cancelar reserva |
| POST | `/slots/:slot_id/waitlist_entries` | Anotarse en espera |
| GET | `/up` | Health check |

## Estado actual

- Pruebas de modelo para reservas, capacidad y lista de espera
  (`bundle exec rails test`).
