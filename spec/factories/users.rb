# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "user#{i}@gmail.com" }
    password { 'user123qwE!@' }
    confirmed_at { DateTime.now }

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
