class AddStatsToInsights < ActiveRecord::Migration[6.1]
  def change
    add_column :insights, :stats, :jsonb, null: false, default: {}
  end
end
