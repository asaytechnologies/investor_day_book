# frozen_string_literal: true

module Portfolios
  module Index
    class ListElementComponent < ViewComponent::Base
      def initialize(portfolio:)
        @portfolio = portfolio
        @income    = @portfolio.cashes.income.where.not(amount_cents: 0)
        @balance   = @portfolio.cashes.balance.where.not(amount_cents: 0)
      end
    end
  end
end
