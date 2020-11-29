# frozen_string_literal: true

FactoryBot.define do
  factory :portfolios_cashes_operation, class: 'Portfolios::Cashes::Operation' do
    amount_cents { 100 }
    association :cash, factory: :portfolios_cash
  end
end
