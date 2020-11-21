# frozen_string_literal: true

class HomeComponent < ViewComponent::Base
  def initialize(quote:)
    @quote = quote
  end
end
