class CreateExchanges < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto'
    enable_extension 'uuid-ossp'

    create_table :exchanges do |t|
      t.jsonb :name, null: false, default: {}
      t.timestamps
    end
  end
end
