class AddUploadableToUploads < ActiveRecord::Migration[6.1]
  def change
    add_column :uploads, :uploadable_id, :integer
    add_column :uploads, :uploadable_type, :string
    add_index :uploads, [:uploadable_id, :uploadable_type]
  end
end
