class AddExternalIdToUsersPositions < ActiveRecord::Migration[6.1]
  def change
    add_column :users_positions, :external_id, :string
  end
end
