class AddPriceToQuotesAndPositions < ActiveRecord::Migration[6.1]
  def change
    add_column :quotes, :price, :decimal, precision: 15, scale: 6
    add_column :users_positions, :price, :decimal, precision: 15, scale: 6

    Quote.find_each do |quote|
      quote.update(price: quote.price_cents / 100.0)
    end
    Users::Position.find_each do |position|
      position.update(price: position.price_cents / 100.0)
    end
  end
end
