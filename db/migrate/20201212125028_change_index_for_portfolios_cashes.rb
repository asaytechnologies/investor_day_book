class ChangeIndexForPortfoliosCashes < ActiveRecord::Migration[6.1]
  def change
    remove_index :portfolios_cashes, name: 'index_portfolios_cashes_on_portfolio_id_and_amount_currency'
    add_index :portfolios_cashes, [:portfolio_id, :amount_currency, :balance], unique: true, name: 'index_portfolios_cashes_on_portfolio_id_and_amount_currency'
  end
end
