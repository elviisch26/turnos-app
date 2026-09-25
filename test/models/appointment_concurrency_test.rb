# Prueba de sobrerreserva ante reserva concurrente con Appointment.book!.
#
# Sin transacciones: los hilos necesitan conexiones propias y ver los datos
# publicados. La limpieza se realiza a mano en el bloque ensure.
require "test_helper"

class AppointmentConcurrencyTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  test "solo la capacidad reserva ante reserva concurrente" do
    @negocio = Business.create!(name: "Negocio Concurrencia", time_zone: "America/Argentina/Buenos_Aires")
    @servicio = @negocio.services.create!(name: "Servicio Concurrencia", duration_min: 30, capacity: 2)
    inicio = Time.current.change(hour: 9, min: 0, sec: 0) + 2.days
    @slot = @servicio.slots.create!(starts_at: inicio, ends_at: inicio + 30.minutes, capacity: 2)

    resultados = Queue.new
    hilos = 4.times.map do |i|
      Thread.new do
        begin
          Appointment.book!(
            slot: @slot,
            customer_name: "Cliente #{i}",
            customer_email: "concurrente#{i}@example.com"
          )
          resultados << :ok
        rescue Appointment::SlotFullError
          resultados << :lleno
        rescue => error
          resultados << error
        end
      end
    end
    hilos.each(&:join)

    estados = []
    4.times { estados << resultados.pop }

    errores = estados.grep(Exception)
    assert errores.empty?, "Errores inesperados en hilos: #{errores.map(&:message).inspect}"
    assert_equal 2, estados.count(:ok)
    assert_equal 2, estados.count(:lleno)
    assert_equal 2, @slot.appointments.confirmed.count
    assert_equal [1, 2], @slot.waitlist_entries.order(:position).pluck(:position)
  ensure
    sid = @slot.id if defined?(@slot) && @slot
    Appointment.where(slot_id: sid).delete_all if sid
    WaitlistEntry.where(slot_id: sid).delete_all if sid
    Slot.where(id: sid).delete_all if sid
    Service.where(id: @servicio.id).delete_all if defined?(@servicio) && @servicio
    Business.where(id: @negocio.id).delete_all if defined?(@negocio) && @negocio
  end
end
