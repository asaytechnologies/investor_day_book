class CreateUsersAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :users_accounts do |t|
      t.integer :user_id
      t.string :name, limit: 255
      t.timestamps
    end
    add_index :users_accounts, :user_id
  end
end
