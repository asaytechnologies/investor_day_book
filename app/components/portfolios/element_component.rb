# frozen_string_literal: true

module Portfolios
  class ElementComponent < ViewComponent::Base
    def initialize(portfolio:)
      @portfolio = portfolio
    end
  end
end
