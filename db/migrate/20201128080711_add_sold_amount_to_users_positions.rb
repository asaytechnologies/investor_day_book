class AddSoldAmountToUsersPositions < ActiveRecord::Migration[6.0]
  def change
    add_column :users_positions, :sold_amount, :integer, null: false, default: 0
    add_column :users_positions, :sold_all, :boolean, null: false, default: false
    add_column :users_positions, :selling_position, :boolean, null: false, default: false
  end
end
