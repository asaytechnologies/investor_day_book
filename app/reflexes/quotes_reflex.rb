# frozen_string_literal: true

class QuotesReflex < ApplicationReflex
  def search(query='', locale='en')
    quote_ids = query.blank? ? [] : Quotes::SearchService.call(query: query).result&.map(&:id)

    current_locale(locale)
    morph '#quotes', AnalyticsController.render(Analytics::QuotesComponent.new(quote_ids: quote_ids))
  end
end
