class AddGuidToPortfolios < ActiveRecord::Migration[6.1]
  def change
    add_column :portfolios, :guid, :string, index: true
  end
end
