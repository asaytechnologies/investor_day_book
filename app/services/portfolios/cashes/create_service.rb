# frozen_string_literal: true

module Portfolios
  module Cashes
    class CreateService
      prepend BasicService

      def call(portfolio:)
        [true, false].each do |balance|
          Cashable::AVAILABLE_CURRENCIES.each do |currency|
            portfolio.cashes.create(amount: Money.new(0, currency), balance: balance)
            portfolio.user.cashes.find_or_create_by(amount_currency: currency.upcase, balance: balance) do |cash|
              cash.amount_cents = 0
            end
          end
        end
      end
    end
  end
end
