class CreateQuotes < ActiveRecord::Migration[6.0]
  def change
    create_table :quotes do |t|
      t.integer :security_id, index: true
      t.integer :source
      t.timestamps
    end
  end
end
