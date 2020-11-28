# frozen_string_literal: true

class QuotesReflex < ApplicationReflex
  def search(query = '', locale = 'en')
    return unless query.size > 2

    quotes_ids = Quote.search("*#{query}*").map(&:id)
    quotes = Quote.where(id: quotes_ids).includes(:security).order('securities.type DESC')

    set_locale(locale)
    morph '#quotes', PortfolioController.render(Portfolios::QuotesComponent.new(quotes: quotes))
  end
end
