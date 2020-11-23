# frozen_string_literal: true

module Quotes
  class AddReflex < ApplicationReflex
    def create_position(args={})
      portfolio = Portfolio.find_or_create_by(user: current_user)
      quote     = Quote.find_by(id: args['quote_id'].to_i)

      portfolio.positions.create(
        quote:  quote,
        price:  Money.new(args['price'].to_f * 100, quote.price_currency),
        amount: args['amount'].to_i
      )
    end
  end
end
