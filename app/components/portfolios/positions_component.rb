# frozen_string_literal: true

module Portfolios
  class PositionsComponent < ViewComponent::Base
    def initialize(positions:)
      @positions = positions
    end
  end
end
