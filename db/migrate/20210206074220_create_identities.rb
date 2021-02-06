class CreateIdentities < ActiveRecord::Migration[6.1]
  def change
    create_table :identities do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.integer :user_id
      t.timestamps
    end
    add_index :identities, [:uid, :provider]
    add_index :identities, :user_id
  end
end
