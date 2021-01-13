# frozen_string_literal: true

module Shared
  class HeaderComponent < ViewComponent::Base
    def initialize(current_user:)
      @current_user = current_user
    end

    def change_locale(locale)
      url_for(request.params.merge(locale: locale.to_s))
    end

    def gravatar_source
      "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(@current_user.email.downcase)}"
    end
  end
end
