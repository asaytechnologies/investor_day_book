class AddSourceToPortfolios < ActiveRecord::Migration[6.1]
  def change
    add_column :portfolios, :source, :integer
  end
end
