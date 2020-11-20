class AddBoardToQuotes < ActiveRecord::Migration[6.0]
  def change
    add_column :quotes, :board, :string, index: true
    add_column :quotes, :figi, :string, index: true
    add_column :securities, :isin, :string, index: true
  end
end
