class AddCashableToPortfoliosCashes < ActiveRecord::Migration[6.1]
  def change
    add_column :portfolios_cashes, :cashable_id, :integer
    add_column :portfolios_cashes, :cashable_type, :string
    add_index :portfolios_cashes, [:cashable_id, :cashable_type]

    Portfolios::Cash.find_each do |cash|
      cash.update(cashable_id: cash.portfolio_id, cashable_type: 'Portfolio')
    end
  end
end
