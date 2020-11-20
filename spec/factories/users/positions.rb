# frozen_string_literal: true

FactoryBot.define do
  factory :users_position, class: 'Users::Position' do
    amount { 1 }
    association :user
    association :users_account
    association :security, factory: :share
  end
end
