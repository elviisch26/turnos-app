# Pruebas de reserva, espera y cancelación de Appointment.
require "test_helper"

class AppointmentTest < ActiveSupport::TestCase
  setup do
    @negocio = Business.create!(name: "Negocio Appointment", time_zone: "America/Argentina/Buenos_Aires")
    @servicio = @negocio.services.create!(name: "Servicio Appointment", duration_min: 30, capacity: 2)
    inicio = Time.current.tomorrow.change(hour: 10, min: 0, sec: 0)
    @slot = @servicio.slots.create!(starts_at: inicio, ends_at: inicio + 30.minutes, capacity: 1)
  end

  test "book! crea reserva confirmada con lugar" do
    reserva = Appointment.book!(slot: @slot, customer_name: "Ana", customer_email: "ana@example.com")

    assert reserva.persisted?
    assert reserva.confirmed?
    assert @slot.reload.full?
  end

  test "book! sin lugar propaga SlotFullError y anota en espera" do
    Appointment.book!(slot: @slot, customer_name: "Ana", customer_email: "ana@example.com")

    error = assert_raises(Appointment::SlotFullError) do
      Appointment.book!(slot: @slot, customer_name: "Beto", customer_email: "beto@example.com")
    end
    assert_match "capacidad máxima", error.message

    espera = @slot.waitlist_entries.order(:position)
    assert_equal %w[beto@example.com], espera.map(&:customer_email)
    assert_equal [1], espera.map(&:position)
  end

  test "validar correo y unicidad de reserva activa por horario" do
    Appointment.book!(slot: @slot, customer_name: "Ana", customer_email: "ana@example.com")

    invalida = Appointment.new(slot: @slot, customer_name: "X", customer_email: "no-es-correo")
    refute invalida.valid?
    assert_includes invalida.errors[:customer_email], "no es válido"

    duplicada = Appointment.new(slot: @slot, customer_name: "Ana", customer_email: "ana@example.com")
    refute duplicada.valid?
    assert_includes duplicada.errors[:customer_email], "ya posee una reserva activa en este horario"
  end

  test "cancelada libera el correo para reservar de nuevo" do
    reserva = Appointment.book!(slot: @slot, customer_name: "Ana", customer_email: "ana@example.com")
    reserva.cancel!

    assert reserva.reload.cancelled?

    nueva = Appointment.book!(slot: @slot, customer_name: "Ana", customer_email: "ana@example.com")
    assert nueva.confirmed?
  end

  test "cancel! promueve la primera espera y reordena posiciones" do
    reserva = Appointment.book!(slot: @slot, customer_name: "Ana", customer_email: "ana@example.com")
    assert_raises(Appointment::SlotFullError) do
      Appointment.book!(slot: @slot, customer_name: "Beto", customer_email: "beto@example.com")
    end
    WaitlistEntry.enqueue!(slot: @slot, customer_name: "Carla", customer_email: "carla@example.com")

    reserva.cancel!

    assert @slot.appointments.confirmed.exists?(customer_email: "beto@example.com")
    assert_nil WaitlistEntry.find_by(customer_email: "beto@example.com", slot_id: @slot.id)
    assert_equal 1, WaitlistEntry.find_by(customer_email: "carla@example.com", slot_id: @slot.id).position
  end
end
