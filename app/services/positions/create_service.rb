# frozen_string_literal: true

module Positions
  class CreateService
    prepend BasicService

    def call(portfolio:, quote:, price:, amount:)
      portfolio.positions.create(
        quote:  quote,
        price:  price,
        amount: amount
      )
    end
  end
end
