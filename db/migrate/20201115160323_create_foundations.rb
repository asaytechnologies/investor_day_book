class CreateFoundations < ActiveRecord::Migration[6.0]
  def change
    create_table :foundations do |t|
      t.string :ticker, limit: 255
      t.jsonb :name, null: false, default: {}
      t.string :uuid, null: false, default: 'gen_random_uuid()'
      t.timestamps
    end

    add_index :foundations, :ticker
  end
end
