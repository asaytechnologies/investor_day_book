# frozen_string_literal: true

module Shared
  class HeaderComponent < ViewComponent::Base
    include ApplicationHelper

    def initialize(current_user:)
      @current_user = current_user
    end

    def gravatar_source
      "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(@current_user.email.downcase)}?s=96"
    end
  end
end
