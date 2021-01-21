# frozen_string_literal: true

module Shared
  class NavigationComponent < ViewComponent::Base
    def initialize(current_user:)
      @current_user = current_user
    end
  end
end
