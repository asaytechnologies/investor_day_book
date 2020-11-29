# frozen_string_literal: true

module Shared
  class SidebarComponent < ViewComponent::Base
    def initialize(title:, window_index:)
      @title        = title
      @window_index = window_index
    end
  end
end
