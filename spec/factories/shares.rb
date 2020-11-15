# frozen_string_literal: true

FactoryBot.define do
  factory :share do
    sequence(:ticker) { |i| "YNDX#{i}" }
    name { { en: 'Yandex', ru: 'Яндекс' } }
  end
end
