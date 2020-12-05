# frozen_string_literal: true

module Portfolios
  module Index
    class ListElementComponent < ViewComponent::Base
      def initialize(portfolio:)
        @portfolio = portfolio
        @caches    = @portfolio.cashes.where.not(amount_cents: 0)
      end
    end
  end
end
