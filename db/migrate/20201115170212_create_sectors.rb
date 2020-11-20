class CreateSectors < ActiveRecord::Migration[6.0]
  def change
    create_table :sectors do |t|
      t.jsonb :name, null: false, default: {}
      t.timestamps
    end
    add_column :industries, :sector_id, :integer
    add_index :industries, :sector_id
  end
end
