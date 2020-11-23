class CreatePortfolios < ActiveRecord::Migration[6.0]
  def change
    create_table :portfolios do |t|
      t.integer :user_id, index: true
      t.string :name, limit: 255
      t.timestamps
    end
  end
end
