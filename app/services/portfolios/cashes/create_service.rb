# frozen_string_literal: true

module Portfolios
  module Cashes
    class CreateService
      prepend BasicService

      def call(portfolio:)
        Cashable::AVAILABLE_CURRENCIES.each do |currency|
          portfolio.cashes.create(amount: Money.new(0, currency))
        end
      end
    end
  end
end
