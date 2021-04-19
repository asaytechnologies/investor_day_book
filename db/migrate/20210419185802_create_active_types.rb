class CreateActiveTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :active_types do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :active_types, :name, unique: true
  end
end
