class AddSectorToSecurities < ActiveRecord::Migration[6.0]
  def change
    add_column :securities, :sector_id, :integer
    add_index :securities, :sector_id
  end
end
