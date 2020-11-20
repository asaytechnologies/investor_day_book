class CreateQuotes < ActiveRecord::Migration[6.0]
  def change
    create_table :quotes do |t|
      t.integer :exchange_id
      t.integer :security_id
      t.timestamps
    end
    add_index :quotes, [:security_id, :exchange_id]
  end
end
