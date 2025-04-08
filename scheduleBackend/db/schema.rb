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

ActiveRecord::Schema[8.0].define(version: 2025_04_08_184621) do
  create_table "tasks", force: :cascade do |t|
    t.string "title", null: false
    t.date "start_date"
    t.date "end_date"
    t.datetime "deadline"
    t.integer "priority"
    t.integer "user_id"
    t.string "start_time"
    t.string "end_time"
    t.text "days_of_week", default: ""
    t.boolean "am_start", default: true
    t.boolean "am_end", default: true
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "canvas_api_token"
    t.string "refresh_token"
    t.datetime "refresh_token_expires_at"
  end

  add_foreign_key "tasks", "users"
end
