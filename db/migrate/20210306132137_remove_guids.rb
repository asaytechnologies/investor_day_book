class RemoveGuids < ActiveRecord::Migration[6.1]
  def change
    remove_column :portfolios, :guid
    remove_column :uploads, :guid
  end
end
