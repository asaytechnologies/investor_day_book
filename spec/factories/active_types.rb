# frozen_string_literal: true

FactoryBot.define do
  factory :active_type do
    trait :share do
      name { 'Share' }
    end

    trait :bond do
      name { 'Bond' }
    end

    trait :foundation do
      name { 'Foundation' }
    end

    trait :cash do
      name { 'Portfolios::Cash' }
    end
  end
end
