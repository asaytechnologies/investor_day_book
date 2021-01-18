# frozen_string_literal: true

module Shared
  class FooterComponent < ViewComponent::Base
    include ApplicationHelper

    def initialize(change_locale: false)
      @change_locale = change_locale
    end
  end
end
