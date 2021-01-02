# frozen_string_literal: true

FactoryBot.define do
  factory :upload do
    guid { '12345678asdf' }
    source { 'tinkoff' }
    name { 'portfolio_initial_data' }
    association :user

    trait :with_file do
      file {
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/tinkoff.xls'), 'application/vnd.ms-excel')
      }
    end
  end
end
