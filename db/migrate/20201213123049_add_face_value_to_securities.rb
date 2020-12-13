class AddFaceValueToSecurities < ActiveRecord::Migration[6.1]
  def change
    add_column :quotes, :face_value_cents, :integer
  end
end
