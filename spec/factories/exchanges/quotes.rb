# frozen_string_literal: true

FactoryBot.define do
  factory :quote, class: 'Exchanges::Quote' do
    amount { 1 }
    price_cents { 100 }
    price_currency { 'USD' }
    association :exchange
    association :securitiable, factory: :share
  end
end
