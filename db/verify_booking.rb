# Verificar el flujo de reserva y el control de capacidad.
# Ejecutar con: bundle exec rails runner db/verify_booking.rb

# Buscar el primer slot del servicio de corte.
slot = Slot.joins(:service).where(services: { name: "Corte de cabello" }).order(:starts_at).first
abort "ERROR: no existir slots para verificar" if slot.nil?

# Limpiar reservas previas del slot para repetir la verificación.
slot.appointments.delete_all
slot.waitlist_entries.delete_all
slot.update!(capacity: 1)

# Crear 1 reserva dentro de capacidad.
primera = Appointment.book!(
  slot: slot,
  customer_name: "Ana Pérez",
  customer_email: "ana@example.com"
)
puts "Primera reserva creada: id=#{primera.id} estado=#{primera.status}"

# Intentar una segunda reserva sobre capacidad y verificar el rechazo.
begin
  Appointment.book!(
    slot: slot,
    customer_name: "Luis Gómez",
    customer_email: "luis@example.com"
  )
  puts "ERROR: la segunda reserva no debió crearse"
  exit 1
rescue Appointment::SlotFullError => error
  puts "Segunda reserva rechazada: #{error.message}"
end

puts "Confirmadas=#{slot.appointments.confirmed.count} Capacidad=#{slot.capacity}"
puts "Lista de espera=#{slot.waitlist_entries.count}"
puts "VERIFICACIÓN EXITOSA"
