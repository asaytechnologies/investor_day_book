class CreateIndustries < ActiveRecord::Migration[6.0]
  def change
    create_table :industries do |t|
      t.jsonb :name, null: false, default: {}
      t.timestamps
    end
    add_column :securities, :industry_id, :integer
    add_index :securities, :industry_id
  end
end
