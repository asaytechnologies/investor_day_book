# frozen_string_literal: true

FactoryBot.define do
  factory :foundation do
    sequence(:ticker) { |i| "YNDX#{i}" }
    name { { en: 'Yandex Foundation', ru: 'Яндекс Фонд' } }
  end
end
