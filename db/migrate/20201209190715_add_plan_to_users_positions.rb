class AddPlanToUsersPositions < ActiveRecord::Migration[6.0]
  def change
    add_column :users_positions, :plan, :boolean, null: false, default: false
  end
end
