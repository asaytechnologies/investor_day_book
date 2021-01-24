# frozen_string_literal: true

module Analytics
  class QuotesComponent < ViewComponent::Base
    include ViewHelper

    def initialize(quote_ids: [])
      @quotes =
        Quote
        .where(id: quote_ids)
        .includes(:security)
        .group_by { |e| e.security.type }
    end
  end
end
