# frozen_string_literal: true

module PageWrappers
  class PageComponent < ViewComponent::Base
    def change_locale(locale)
      url_for(request.params.merge(locale: locale.to_s))
    end
  end
end
