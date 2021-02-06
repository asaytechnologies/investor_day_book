# frozen_string_literal: true

FactoryBot.define do
  factory :identity do
    uid { 111_111 }
    provider { 'google_oauth2' }
    association :user
  end
end
