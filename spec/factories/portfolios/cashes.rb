# frozen_string_literal: true

FactoryBot.define do
  factory :portfolios_cash, class: 'Portfolios::Cash' do
    amount_cents { 100 }
    amount_currency { 'USD' }
    association :portfolio
  end
end
