class CreateBondsCoupons < ActiveRecord::Migration[6.1]
  def change
    create_table :bonds_coupons do |t|
      t.integer :quote_id, index: true
      t.datetime :payment_date
      t.decimal :coupon_value, precision: 12, scale: 6
      t.timestamps
    end
  end
end
