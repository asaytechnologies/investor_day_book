# frozen_string_literal: true

module Portfolios
  class ListComponent < ViewComponent::Base
    def initialize(portfolios:)
      @portfolios = portfolios
    end
  end
end
