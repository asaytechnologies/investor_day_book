# frozen_string_literal: true

FactoryBot.define do
  factory :quote, class: 'Exchanges::Quote' do
    association :exchange
    association :securitiable, factory: :share
  end
end
