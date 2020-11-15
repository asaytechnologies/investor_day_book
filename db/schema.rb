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

ActiveRecord::Schema.define(version: 2020_11_15_162247) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "bonds", force: :cascade do |t|
    t.string "ticker", limit: 255
    t.jsonb "name", default: {}, null: false
    t.string "uuid", default: "gen_random_uuid()", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ticker"], name: "index_bonds_on_ticker", unique: true
  end

  create_table "exchanges", force: :cascade do |t|
    t.jsonb "name", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "exchanges_quotes", force: :cascade do |t|
    t.integer "exchange_id"
    t.integer "securitiable_id"
    t.string "securitiable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exchange_id"], name: "index_exchanges_quotes_on_exchange_id"
    t.index ["securitiable_id", "securitiable_type"], name: "index_exchanges_quotes_on_securitiable_id_and_securitiable_type"
  end

  create_table "foundations", force: :cascade do |t|
    t.string "ticker", limit: 255
    t.jsonb "name", default: {}, null: false
    t.string "uuid", default: "gen_random_uuid()", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ticker"], name: "index_foundations_on_ticker", unique: true
  end

  create_table "shares", force: :cascade do |t|
    t.string "ticker", limit: 255
    t.jsonb "name", default: {}, null: false
    t.string "uuid", default: "gen_random_uuid()", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ticker"], name: "index_shares_on_ticker", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_accounts", force: :cascade do |t|
    t.integer "user_id"
    t.string "name", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_users_accounts_on_user_id"
  end

end
