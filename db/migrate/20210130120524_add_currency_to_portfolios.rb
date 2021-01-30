class AddCurrencyToPortfolios < ActiveRecord::Migration[6.1]
  def change
    add_column :portfolios, :currency, :integer
  end
end
