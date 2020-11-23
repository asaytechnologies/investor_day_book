class CreateUsersPositions < ActiveRecord::Migration[6.0]
  def change
    create_table :users_positions do |t|
      t.integer :portfolio_id, index: true
      t.integer :quote_id, index: true
      t.integer :amount, null: false, default: 1
      t.timestamps
    end
  end
end
