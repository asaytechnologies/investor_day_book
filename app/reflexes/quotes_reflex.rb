# frozen_string_literal: true

class QuotesReflex < ApplicationReflex
  def search(value='')
    return unless value.size > 2

    quotes_ids = Quote.search("*#{value}*").map(&:id)
    quotes = Quote.where(id: quotes_ids).includes(:security).order('securities.type DESC')

    morph '#quotes', PortfolioController.render(Portfolios::QuotesComponent.new(quotes: quotes))
  end
end
