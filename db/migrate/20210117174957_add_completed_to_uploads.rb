class AddCompletedToUploads < ActiveRecord::Migration[6.1]
  def change
    add_column :uploads, :completed, :boolean, null: false, default: false
  end
end
