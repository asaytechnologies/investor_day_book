# frozen_string_literal: true

FactoryBot.define do
  factory :insight do
    association :parentable, factory: :portfolio
    association :insightable, factory: :quote
  end
end
