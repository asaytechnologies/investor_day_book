class CreateInsights < ActiveRecord::Migration[6.1]
  def change
    create_table :insights do |t|
      t.integer :portfolio_id
      t.integer :quote_id
      t.integer :insightable_id
      t.string :insightable_type
      t.integer :amount
      t.decimal :price, precision: 15, scale: 6
      t.boolean :plan, null: false, default: false
      t.timestamps
    end
    add_index :insights, [:portfolio_id, :quote_id, :plan], unique: true
    add_index :insights, [:insightable_id, :insightable_type]
  end
end
