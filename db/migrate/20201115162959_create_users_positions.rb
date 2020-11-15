class CreateUsersPositions < ActiveRecord::Migration[6.0]
  def change
    create_table :users_positions do |t|
      t.integer :user_id
      t.integer :users_account_id
      t.integer :securitiable_id
      t.string :securitiable_type
      t.integer :amount, null: false, default: 1
      t.timestamps
    end

    add_index :users_positions, :users_account_id
    add_index :users_positions, [:user_id, :securitiable_id, :securitiable_type], name: 'users_positions_securitiable_index'
  end
end
