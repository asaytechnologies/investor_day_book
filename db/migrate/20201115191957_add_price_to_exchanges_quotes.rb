class AddPriceToExchangesQuotes < ActiveRecord::Migration[6.0]
  def change
    add_monetize :exchanges_quotes, :price
    add_column :exchanges_quotes, :amount, :integer, null: false, default: 1
  end
end
