# frozen_string_literal: true

class Bond < Security
  has_many :coupons, class_name: 'Bonds::Coupon', through: :quotes
end
