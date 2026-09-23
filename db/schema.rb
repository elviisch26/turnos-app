# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_09_23_120005) do
  create_table "appointments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "slot_id", null: false
    t.string "customer_name", null: false
    t.string "customer_email", null: false
    t.integer "status", default: 0, null: false
    t.virtual "active_booking_key", type: :string, limit: 512, as: "if((`status` = 2),NULL,concat(`slot_id`,_utf8mb4'|',`customer_email`))", stored: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_booking_key"], name: "index_appointments_on_active_booking_key", unique: true
    t.index ["slot_id", "status"], name: "index_appointments_on_slot_id_and_status"
    t.index ["slot_id"], name: "index_appointments_on_slot_id"
  end

  create_table "businesses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "time_zone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_businesses_on_name", unique: true
  end

  create_table "services", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "business_id", null: false
    t.string "name", null: false
    t.integer "duration_min", null: false
    t.integer "capacity", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id", "name"], name: "index_services_on_business_id_and_name", unique: true
    t.index ["business_id"], name: "index_services_on_business_id"
  end

  create_table "slots", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.integer "capacity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id", "starts_at"], name: "index_slots_on_service_id_and_starts_at", unique: true
    t.index ["service_id"], name: "index_slots_on_service_id"
  end

  create_table "waitlist_entries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "slot_id", null: false
    t.string "customer_name", null: false
    t.string "customer_email", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slot_id", "customer_email"], name: "index_waitlist_on_slot_and_email", unique: true
    t.index ["slot_id", "position"], name: "index_waitlist_on_slot_and_position", unique: true
    t.index ["slot_id"], name: "index_waitlist_entries_on_slot_id"
  end

  add_foreign_key "appointments", "slots"
  add_foreign_key "services", "businesses"
  add_foreign_key "slots", "services"
  add_foreign_key "waitlist_entries", "slots"
end
