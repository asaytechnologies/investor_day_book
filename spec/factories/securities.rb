# frozen_string_literal: true

FactoryBot.define do
  factory :security do
    ticker { 'TECH' }
    name { { en: 'Yandex Bond', ru: 'Яндекс Облигация' } }
  end
end
