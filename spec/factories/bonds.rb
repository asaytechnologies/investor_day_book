# frozen_string_literal: true

FactoryBot.define do
  factory :bond do
    sequence(:ticker) { |i| "YNDX#{i}" }
    name { { en: 'Yandex Bond', ru: 'Яндекс Облигация' } }
  end
end
