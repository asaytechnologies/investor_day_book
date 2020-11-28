# frozen_string_literal: true

FactoryBot.define do
  factory :users_position, class: 'Users::Position' do
    amount { 1 }
    sold_amount { 0 }
    sold_all { false }
    selling_position { false }
    price_cents { 100 }
    price_currency { 'USD' }
    association :portfolio
    association :quote
  end
end
