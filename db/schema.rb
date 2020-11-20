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

ActiveRecord::Schema.define(version: 2020_11_17_190325) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "exchanges", force: :cascade do |t|
    t.jsonb "name", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "code"
  end

  create_table "industries", force: :cascade do |t|
    t.jsonb "name", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sector_id"
    t.index ["sector_id"], name: "index_industries_on_sector_id"
  end

  create_table "quotes", force: :cascade do |t|
    t.integer "exchange_id"
    t.integer "security_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.string "board"
    t.string "figi"
    t.index ["security_id", "exchange_id"], name: "index_quotes_on_security_id_and_exchange_id"
  end

  create_table "sectors", force: :cascade do |t|
    t.jsonb "name", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "securities", force: :cascade do |t|
    t.string "ticker", limit: 255
    t.string "type", null: false
    t.jsonb "name", default: {}, null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "industry_id"
    t.string "isin"
    t.index ["industry_id"], name: "index_securities_on_industry_id"
    t.index ["ticker"], name: "index_securities_on_ticker"
    t.index ["uuid"], name: "index_securities_on_uuid"
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

  create_table "users_positions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "users_account_id"
    t.integer "security_id"
    t.integer "amount", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "security_id"], name: "index_users_positions_on_user_id_and_security_id"
    t.index ["users_account_id"], name: "index_users_positions_on_users_account_id"
  end

end
