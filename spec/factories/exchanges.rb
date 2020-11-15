# frozen_string_literal: true

FactoryBot.define do
  factory :exchange do
    name { { en: 'Moscow Exchange', ru: 'Московская биржа' } }
  end
end
