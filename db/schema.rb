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

ActiveRecord::Schema.define(version: 2021_01_02_193905) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bonds_coupons", force: :cascade do |t|
    t.integer "quote_id"
    t.datetime "payment_date"
    t.decimal "coupon_value", precision: 12, scale: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["quote_id"], name: "index_bonds_coupons_on_quote_id"
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.string "base_currency"
    t.decimal "rate_amount", precision: 12, scale: 6
    t.string "rate_currency"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["base_currency", "rate_currency"], name: "index_exchange_rates_on_base_currency_and_rate_currency", unique: true
    t.index ["rate_currency"], name: "index_exchange_rates_on_rate_currency"
  end

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
    t.string "guid"
    t.index ["user_id"], name: "index_portfolios_on_user_id"
  end

  create_table "portfolios_cashes", force: :cascade do |t|
    t.integer "portfolio_id"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "balance", default: false, null: false
    t.index ["portfolio_id", "amount_currency", "balance"], name: "index_portfolios_cashes_on_portfolio_id_and_amount_currency", unique: true
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
    t.integer "face_value_cents"
    t.decimal "average_year_dividents_amount", precision: 12, scale: 6
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

  create_table "uploads", force: :cascade do |t|
    t.string "guid"
    t.string "name"
    t.string "source"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_uploads_on_user_id"
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
    t.boolean "plan", default: false, null: false
    t.index ["portfolio_id"], name: "index_users_positions_on_portfolio_id"
    t.index ["quote_id"], name: "index_users_positions_on_quote_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
