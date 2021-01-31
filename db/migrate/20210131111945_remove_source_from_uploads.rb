class RemoveSourceFromUploads < ActiveRecord::Migration[6.1]
  def change
    remove_column :uploads, :source
  end
end
