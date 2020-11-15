class CreateIndustries < ActiveRecord::Migration[6.0]
  def change
    create_table :industries do |t|
      t.jsonb :name, null: false, default: {}
      t.timestamps
    end

    add_column :shares, :industry_id, :integer
    add_index :shares, :industry_id
    add_column :bonds, :industry_id, :integer
    add_index :bonds, :industry_id
  end
end
