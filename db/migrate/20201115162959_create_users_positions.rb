class CreateUsersPositions < ActiveRecord::Migration[6.0]
  def change
    create_table :users_positions do |t|
      t.integer :user_id
      t.integer :users_account_id
      t.integer :security_id
      t.integer :amount, null: false, default: 1
      t.timestamps
    end
    add_index :users_positions, :users_account_id
    add_index :users_positions, [:user_id, :security_id]
  end
end
