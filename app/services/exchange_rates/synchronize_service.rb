# frozen_string_literal: true

module ExchangeRates
  class SynchronizeService
    prepend BasicService

    SAME_CURRENCY_COEFFICIENT = 1

    def initialize(
      exchange_rate_service: ExchangeRatesApi::Client
    )
      @exchange_rate_service = exchange_rate_service.new
    end

    def call
      Cashable::AVAILABLE_CURRENCIES_UPCASE.each do |base_currency|
        Cashable::AVAILABLE_CURRENCIES_UPCASE.each do |rate_currency|
          perform_exchage_rate(base_currency, rate_currency)
        end
      end
    end

    private

    def perform_exchage_rate(base_currency, rate_currency)
      exchange_rate = ExchangeRate.find_or_initialize_by(base_currency: base_currency, rate_currency: rate_currency)
      rate_amount = fetch_exchange_rate(base_currency, rate_currency)
      return unless rate_amount

      exchange_rate.rate_amount = rate_amount
      exchange_rate.save
    end

    def fetch_exchange_rate(base_currency, rate_currency)
      return SAME_CURRENCY_COEFFICIENT if base_currency == rate_currency

      response = @exchange_rate_service.latest(base: base_currency, symbols: [rate_currency])
      response.dig('rates', rate_currency)&.round(6)
    end
  end
end
