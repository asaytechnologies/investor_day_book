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

  USD_UPCASE = 'USD'
  EUR_UPCASE = 'EUR'
  RUB_UPCASE = 'RUB'

  AVAILABLE_CURRENCIES_UPCASE = [
    USD_UPCASE,
    EUR_UPCASE,
    RUB_UPCASE
  ].freeze
end
