# frozen_string_literal: true

module Portfolios
  module Index
    class ListElementComponent < ViewComponent::Base
      def initialize(portfolio:)
        @portfolio = portfolio
      end
    end
  end
end
