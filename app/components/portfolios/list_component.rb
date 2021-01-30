# frozen_string_literal: true

module Portfolios
  class ListComponent < ViewComponent::Base
    def initialize(current_user:)
      @current_user = current_user
      @portfolios = @current_user.portfolios
    end
  end
end
