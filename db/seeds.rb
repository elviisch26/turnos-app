# Cargar datos mínimos para desarrollo y verificación.
# Ejecutar con: bundle exec rails db:seed

# Crear negocio de ejemplo.
business = Business.find_or_create_by!(name: "Peluquería Central") do |record|
  record.time_zone = "America/Argentina/Buenos_Aires"
end

# Crear servicios de ejemplo.
corte = business.services.find_or_create_by!(name: "Corte de cabello") do |record|
  record.duration_min = 30
  record.capacity = 3
end

barba = business.services.find_or_create_by!(name: "Arreglo de barba") do |record|
  record.duration_min = 20
  record.capacity = 4
end

# Crear 5 slots futuros a partir de mañana a las 9:00.
base = Time.current.tomorrow.change(hour: 9, min: 0, sec: 0)
plan = [
  [corte, base],
  [corte, base + 30.minutes],
  [barba, base + 60.minutes],
  [barba, base + 80.minutes],
  [corte, base + 120.minutes]
]

plan.each do |service, inicio|
  service.slots.find_or_create_by!(starts_at: inicio) do |record|
    record.ends_at = inicio + service.duration_min.minutes
    record.capacity = service.capacity
  end
end

puts "Negocio: #{business.name}"
puts "Servicios: #{business.services.count}"
puts "Slots: #{Slot.count}"
