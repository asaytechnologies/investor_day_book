# frozen_string_literal: true

module Analytics
  class PositionsComponent < ViewComponent::Base
    def initialize(portfolios:, positions:, portfolio: nil)
      @portfolios = portfolios
      @positions  = positions
      @portfolio  = portfolio

      filter_positions if @portfolio
      prepare_portfolio_stats
    end

    private

    def filter_positions
      @positions = @positions.where(portfolio: @portfolio)
    end

    # rubocop: disable Metrics/AbcSize
    def prepare_portfolio_stats
      @portfolio_stats = @positions.group_by(&:quote).each_with_object(basis_stats) do |(quote, positions), acc|
        positions_stats = calculate_positions_stats(positions)

        income = quote.price_cents * positions_stats[:total_amount] - positions_stats[:total_price_cents]

        acc['Total'][quote.price_currency][:income_cents] += income
        acc[quote.security.type][:elements][quote] = {
          total_price_cents:         positions_stats[:total_price_cents],
          total_amount:              positions_stats[:total_amount],
          current_total_price_cents: quote.price_cents * positions_stats[:total_amount],
          income:                    income,
          positions:                 positions
        }
      end
    end
    # rubocop: enable Metrics/AbcSize

    def basis_stats
      {
        'Total'      => {
          'RUB' => { total_cents: 0, income_cents: 0 },
          'USD' => { total_cents: 0, income_cents: 0 },
          'EUR' => { total_cents: 0, income_cents: 0 }
        },
        'Share'      => { name: t('analytics.table.shares_name'), elements: {} },
        'Foundation' => { name: t('analytics.table.foundations_name'), elements: {} },
        'Bond'       => { name: t('analytics.table.bonds_name'), elements: {} }
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
