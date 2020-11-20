# frozen_string_literal: true

FactoryBot.define do
  factory :share, parent: :security, class: 'Share' do
    type { 'Share' }
    name { { en: 'Yandex', ru: 'Яндекс' } }
  end
end
