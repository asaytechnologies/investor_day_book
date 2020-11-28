class CreatePortfoliosCashes < ActiveRecord::Migration[6.0]
  def change
    create_table :portfolios_cashes do |t|
      t.integer :portfolio_id
      t.monetize :amount
      t.timestamps
    end
    add_index :portfolios_cashes, [:portfolio_id, :amount_currency], unique: true
  end
end
