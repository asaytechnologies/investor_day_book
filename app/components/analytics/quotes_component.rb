# frozen_string_literal: true

module Analytics
  class QuotesComponent < ViewComponent::Base
    def initialize(quotes:)
      @quotes = quotes
    end
  end
end
