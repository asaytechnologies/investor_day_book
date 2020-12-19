# frozen_string_literal: true

FactoryBot.define do
  factory :exchange_rate do
    base_currency { 'RUB' }
    rate_currency { 'RUB' }
    rate_amount { 1 }
  end
end
