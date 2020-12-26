class AddAverageYearDividentsAmountToQuotes < ActiveRecord::Migration[6.1]
  def change
    add_column :quotes, :average_year_dividents_amount, :decimal, precision: 12, scale: 6
  end
end
