# frozen_string_literal: true

module Portfolios
  module Cashes
    class CreateService
      prepend BasicService

      def call(portfolio:)
        [true, false].each do |balance|
          Cashable::AVAILABLE_CURRENCIES.each do |currency|
            portfolio.cashes.create(amount: Money.new(0, currency), balance: balance)
          end
        end
      end
    end
  end
end
