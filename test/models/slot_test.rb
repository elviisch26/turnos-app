# Pruebas del cálculo de capacidad y las validaciones de Slot.
require "test_helper"

class SlotTest < ActiveSupport::TestCase
  setup do
    @negocio = Business.create!(name: "Negocio Slot", time_zone: "America/Argentina/Buenos_Aires")
    @servicio = @negocio.services.create!(name: "Servicio Slot", duration_min: 30, capacity: 3)
    inicio = Time.current.tomorrow.change(hour: 9, min: 0, sec: 0)
    @slot = @servicio.slots.create!(starts_at: inicio, ends_at: inicio + 30.minutes, capacity: 2)
  end

  test "remaining_capacity descuenta solo confirmadas" do
    assert_equal 2, @slot.remaining_capacity
    refute @slot.full?

    @slot.appointments.create!(customer_name: "Pend", customer_email: "pend@example.com", status: :pending)
    @slot.appointments.create!(customer_name: "Conf", customer_email: "conf@example.com", status: :confirmed)
    @slot.appointments.create!(customer_name: "Canc", customer_email: "canc@example.com", status: :cancelled)

    assert_equal 1, @slot.confirmed_count
    assert_equal 1, @slot.remaining_capacity
    refute @slot.full?
  end

  test "full? cuando se alcanza la capacidad" do
    2.times do |i|
      @slot.appointments.create!(customer_name: "C#{i}", customer_email: "c#{i}@example.com", status: :confirmed)
    end

    assert @slot.full?
    assert_equal 0, @slot.remaining_capacity
  end

  test "validar capacidad mínima y coherencia temporal" do
    slot = @servicio.slots.new(starts_at: @slot.starts_at + 1.hour, ends_at: @slot.starts_at, capacity: 0)

    refute slot.valid?
    assert_includes slot.errors[:capacity], "debe ser mayor o igual que 1"
    assert_includes slot.errors[:ends_at], "debe ser posterior a la hora de inicio"
  end

  test "validar inicio único por servicio" do
    duplicado = @servicio.slots.new(
      starts_at: @slot.starts_at, ends_at: @slot.starts_at + 30.minutes, capacity: 1
    )

    refute duplicado.valid?
    assert_includes duplicado.errors[:starts_at], "ya se encuentra registrado para este servicio"
  end

  test "next_available_for salta pasados y llenos" do
    @servicio.slots.create!(starts_at: 1.day.ago, ends_at: 1.day.ago + 30.minutes, capacity: 2)
    futuro = @servicio.slots.create!(
      starts_at: 2.days.from_now, ends_at: 2.days.from_now + 30.minutes, capacity: 2
    )
    2.times do |i|
      @slot.appointments.create!(customer_name: "X#{i}", customer_email: "x#{i}@example.com", status: :confirmed)
    end

    assert_equal futuro.id, Slot.next_available_for(@servicio).id
  end

  test "next_available_for devuelve nil sin lugar futuro" do
    @slot.update!(capacity: 1)
    @slot.appointments.create!(customer_name: "C", customer_email: "c@example.com", status: :confirmed)

    assert_nil Slot.next_available_for(@servicio)
  end
end
