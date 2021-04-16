class CreateInsights < ActiveRecord::Migration[6.1]
  def change
    create_table :insights do |t|
      t.integer :parentable_id
      t.string :parentable_type
      t.integer :insightable_id
      t.string :insightable_type
      t.boolean :plan, null: false, default: false
      t.timestamps
    end
    add_index :insights, [:parentable_id, :parentable_type]
    add_index :insights, [:insightable_id, :insightable_type, :plan]
  end
end
