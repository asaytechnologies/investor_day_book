# frozen_string_literal: true

FactoryBot.define do
  factory :foundation, parent: :security, class: 'Foundation' do
    type { 'Foundation' }
    name { { en: 'Yandex Foundation', ru: 'Яндекс Фонд' } }
  end
end
