class CreateSecurities < ActiveRecord::Migration[6.0]
  def change
    create_table :securities do |t|
      t.string :ticker, limit: 255, index: true
      t.string :type, null: false
      t.jsonb :name, null: false, default: {}
      t.uuid :uuid, null: false, default: 'gen_random_uuid()', index: true
      t.timestamps
    end
  end
end
