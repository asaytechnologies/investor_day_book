class AddCurrencyToInsights < ActiveRecord::Migration[6.1]
  def change
    add_column :insights, :currency, :string, null: false, default: ''
  end
end
