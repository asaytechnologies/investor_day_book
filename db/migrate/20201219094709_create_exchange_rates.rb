class CreateExchangeRates < ActiveRecord::Migration[6.1]
  def change
    create_table :exchange_rates do |t|
      t.string :base_currency
      t.decimal :rate_amount, precision: 12, scale: 6
      t.string :rate_currency
      t.timestamps
    end
    add_index :exchange_rates, [:base_currency, :rate_currency], unique: true
    add_index :exchange_rates, :rate_currency
  end
end
