# frozen_string_literal: true

class QuotesReflex < ApplicationReflex
  def search(query='', locale='en')
    quotes_ids = Quotes::SearchService.call(query: query).result&.map(&:id)
    quotes = quotes_ids ? Quote.where(id: quotes_ids).includes(:security).order('securities.type DESC') : []

    current_locale(locale)
    morph '#quotes', AnalyticsController.render(Analytics::QuotesComponent.new(quotes: quotes))
  end
end
