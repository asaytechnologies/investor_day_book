# frozen_string_literal: true

FactoryBot.define do
  factory :exchange do
    source { 0 }
    name { { en: 'Moscow Exchange', ru: 'Московская биржа' } }
  end
end
