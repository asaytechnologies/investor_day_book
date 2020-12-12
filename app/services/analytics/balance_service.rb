# frozen_string_literal: true

module Analytics
  class BalanceService
    prepend BasicService

    EXCHANGE_RATES = { RUB: 1, USD: 74.25, EUR: 90.26 }.freeze

    def call(portfolios:)
      @result =
        portfolios.each_with_object(default_stats) do |portfolio, acc|
          portfolio.cashes.balance.each do |cash|
            currency_symbol = cash.amount_currency.to_sym
            acc[:stats][currency_symbol] += cash.amount_cents
            acc[:summary_cents] += cash.amount_cents * EXCHANGE_RATES[currency_symbol]
          end
        end
    end

    private

    def default_stats
      {
        stats:         {
          RUB: 0,
          USD: 0,
          EUR: 0
        },
        summary_cents: 0
      }
    end
  end
end
