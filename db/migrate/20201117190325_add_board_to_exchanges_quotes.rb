class AddBoardToExchangesQuotes < ActiveRecord::Migration[6.0]
  def change
    add_column :exchanges_quotes, :board, :string
    add_index :exchanges_quotes, :board
  end
end
