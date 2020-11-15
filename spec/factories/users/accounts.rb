# frozen_string_literal: true

FactoryBot.define do
  factory :users_account, class: 'Users::Account' do
    association :user
  end
end
