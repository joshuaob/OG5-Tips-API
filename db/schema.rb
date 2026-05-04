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

ActiveRecord::Schema[8.0].define(version: 2026_05_04_090159) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name"
    t.string "otp_secret", null: false
    t.string "auth_token"
    t.datetime "otp_sent_at"
    t.datetime "last_login_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.index ["auth_token"], name: "index_accounts_on_auth_token", unique: true
    t.index ["email"], name: "index_accounts_on_email", unique: true
  end

  create_table "audio_files", force: :cascade do |t|
    t.bigint "lesson_id", null: false
    t.integer "provider", default: 0, null: false
    t.string "s3_key"
    t.integer "duration"
    t.integer "status", default: 0, null: false
    t.string "content_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_hash"], name: "index_audio_files_on_content_hash"
    t.index ["lesson_id"], name: "index_audio_files_on_lesson_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "audio_files", "lessons"
end
