# frozen_string_literal: true

module Portfolios
  class PositionsComponent < ViewComponent::Base
    def initialize(positions:, portfolio: nil)
      @positions = positions
      @portfolio = portfolio

      filter_positions if @portfolio
      prepare_portfolio_stats
    end

    private

    def filter_positions
      @positions = @positions.where(portfolio: @portfolio)
    end

    def prepare_portfolio_stats
      @portfolio_stats = @positions.group_by(&:quote).each_with_object(basis_stats) do |(quote, positions), acc|
        positions_stats = calculate_positions_stats(positions)
        acc[quote.security.type][:elements][quote] = {
          total_price_cents: positions_stats[:total_price_cents],
          total_amount:      positions_stats[:total_amount],
          positions:         positions
        }
      end
    end

    def basis_stats
      {
        'Share'      => { elements: {} },
        'Foundation' => { elements: {} },
        'Bond'       => { elements: {} }
      }
    end

    def calculate_positions_stats(positions)
      positions.each_with_object(basis_positions_stats) do |position, acc|
        not_sold_amount = position.amount - position.sold_amount

        acc[:total_amount]      += not_sold_amount
        acc[:total_price_cents] += not_sold_amount * position.price_cents
      end
    end

    def basis_positions_stats
      {
        total_price_cents: 0,
        total_amount:      0
      }
    end
  end
end
