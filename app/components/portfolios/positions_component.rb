# frozen_string_literal: true

module Portfolios
  class PositionsComponent < ViewComponent::Base
    def initialize(positions:)
      @positions = positions

      prepare_portfolio_stats
    end

    private

    def prepare_portfolio_stats
      @portfolio_stats = @positions.group_by(&:quote).each_with_object(basis_stats) do |(quote, positions), acc|
        acc[quote.security.type][:elements][quote] = {
          total_price_cents: positions.sum(&:price_cents),
          total_amount:      positions.sum(&:amount),
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
  end
end
