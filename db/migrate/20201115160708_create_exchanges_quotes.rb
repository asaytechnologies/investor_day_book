class CreateExchangesQuotes < ActiveRecord::Migration[6.0]
  def change
    create_table :exchanges_quotes do |t|
      t.integer :exchange_id
      t.integer :securitiable_id
      t.string :securitiable_type
      t.timestamps
    end

    add_index :exchanges_quotes, :exchange_id
    add_index :exchanges_quotes, [:securitiable_id, :securitiable_type]
  end
end
