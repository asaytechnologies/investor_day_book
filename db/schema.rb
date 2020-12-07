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

ActiveRecord::Schema.define(version: 2020_12_07_082152) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "industries", force: :cascade do |t|
    t.jsonb "name", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sector_id"
    t.index ["sector_id"], name: "index_industries_on_sector_id"
  end

  create_table "portfolios", force: :cascade do |t|
    t.integer "user_id"
    t.string "name", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_portfolios_on_user_id"
  end

  create_table "portfolios_cashes", force: :cascade do |t|
    t.integer "portfolio_id"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["portfolio_id", "amount_currency"], name: "index_portfolios_cashes_on_portfolio_id_and_amount_currency", unique: true
  end

  create_table "portfolios_cashes_operations", force: :cascade do |t|
    t.integer "portfolios_cash_id"
    t.integer "amount_cents", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["portfolios_cash_id"], name: "index_portfolios_cashes_operations_on_portfolios_cash_id"
  end

  create_table "quotes", force: :cascade do |t|
    t.integer "security_id"
    t.integer "source"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.string "board"
    t.string "figi"
    t.index ["security_id"], name: "index_quotes_on_security_id"
  end

  create_table "sectors", force: :cascade do |t|
    t.jsonb "name", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "color"
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
    t.integer "sector_id"
    t.index ["industry_id"], name: "index_securities_on_industry_id"
    t.index ["sector_id"], name: "index_securities_on_sector_id"
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

  create_table "users_positions", force: :cascade do |t|
    t.integer "portfolio_id"
    t.integer "quote_id"
    t.integer "amount", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.integer "sold_amount", default: 0, null: false
    t.boolean "sold_all", default: false, null: false
    t.boolean "selling_position", default: false, null: false
    t.index ["portfolio_id"], name: "index_users_positions_on_portfolio_id"
    t.index ["quote_id"], name: "index_users_positions_on_quote_id"
  end

end
