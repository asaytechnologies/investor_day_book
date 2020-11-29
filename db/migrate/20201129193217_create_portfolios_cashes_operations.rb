class CreatePortfoliosCashesOperations < ActiveRecord::Migration[6.0]
  def change
    create_table :portfolios_cashes_operations do |t|
      t.integer :portfolios_cash_id, index: true
      t.integer :amount_cents, null: false, default: 0
      t.timestamps
    end
  end
end
