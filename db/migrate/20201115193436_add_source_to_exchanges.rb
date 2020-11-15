class AddSourceToExchanges < ActiveRecord::Migration[6.0]
  def change
    add_column :exchanges, :source, :integer
  end
end
