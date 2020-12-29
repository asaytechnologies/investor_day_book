# frozen_string_literal: true

FactoryBot.define do
  factory :bonds_coupon, class: 'Bonds::Coupon' do
    payment_date { DateTime.now + 91.days }
    coupon_value { 100.00 }
    association :quote
  end
end
