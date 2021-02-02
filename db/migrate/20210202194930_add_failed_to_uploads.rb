class AddFailedToUploads < ActiveRecord::Migration[6.1]
  def change
    add_column :uploads, :failed, :boolean, null: false, default: false
  end
end
