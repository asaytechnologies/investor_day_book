# frozen_string_literal: true

module Cashable
  extend ActiveSupport::Concern

  USD = 'usd'
  EUR = 'eur'
  RUB = 'rub'

  AVAILABLE_CURRENCIES = [
    USD,
    EUR,
    RUB
  ].freeze
end
