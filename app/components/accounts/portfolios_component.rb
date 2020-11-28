# frozen_string_literal: true

module Accounts
  class PortfoliosComponent < ViewComponent::Base
    def initialize(portfolios:)
      @portfolios = portfolios
    end
  end
end
