class AddLeftToPortfoliosCashes < ActiveRecord::Migration[6.1]
  def change
    add_column :portfolios_cashes, :balance, :boolean, null: false, default: false
  end
end
