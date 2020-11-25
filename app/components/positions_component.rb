# frozen_string_literal: true

class PositionsComponent < ViewComponent::Base
  def initialize(positions:)
    @positions = positions
  end
end
