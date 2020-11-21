# frozen_string_literal: true

module Shared
  class SidebarComponent < ViewComponent::Base
    def initialize(title:)
      @title = title
    end
  end
end
