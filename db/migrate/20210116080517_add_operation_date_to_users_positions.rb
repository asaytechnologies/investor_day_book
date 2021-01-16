class AddOperationDateToUsersPositions < ActiveRecord::Migration[6.1]
  def change
    add_column :users_positions, :operation_date, :datetime
  end
end
