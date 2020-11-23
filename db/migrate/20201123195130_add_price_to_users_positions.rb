class AddPriceToUsersPositions < ActiveRecord::Migration[6.0]
  def change
    add_monetize :users_positions, :price
  end
end
