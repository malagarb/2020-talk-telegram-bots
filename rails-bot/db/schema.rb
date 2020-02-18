# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_15_070503) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "request_interactions", force: :cascade do |t|
    t.integer "chat_id"
    t.string "telegram_date"
    t.string "from_user"
    t.integer "from_user_id"
    t.string "from_ip"
    t.string "language_code"
    t.json "payload_received"
    t.json "payload_received_reply"
    t.json "payload_sent"
    t.string "payload_sent_method"
    t.json "payload_sent_reply"
    t.json "payload_result"
    t.integer "process_status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
