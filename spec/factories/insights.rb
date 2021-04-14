# frozen_string_literal: true

FactoryBot.define do
  factory :insight do
    amount { 1 }
    price { 1.00 }
    association :portfolio
    association :quote
  end
end
