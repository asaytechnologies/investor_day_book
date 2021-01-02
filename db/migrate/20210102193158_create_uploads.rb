class CreateUploads < ActiveRecord::Migration[6.1]
  def change
    create_table :uploads do |t|
      t.string :guid
      t.string :name
      t.string :source
      t.integer :user_id, index: true
      t.timestamps
    end
  end
end
