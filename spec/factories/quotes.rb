# frozen_string_literal: true

FactoryBot.define do
  factory :quote do
    source { 0 }
    price { 1.00 }
    price_cents { 100 }
    price_currency { 'USD' }
    association :security, factory: :share
  end
end
