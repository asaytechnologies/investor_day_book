class AddPriceToQuotes < ActiveRecord::Migration[6.0]
  def change
    add_monetize :quotes, :price
  end
end
