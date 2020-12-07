# frozen_string_literal: true

module Analytics
  class PositionsComponent < ViewComponent::Base
    def initialize(portfolios:, positions:, portfolio: nil)
      @portfolios = portfolios
      @positions  = positions
      @portfolio  = portfolio

      filter_positions if @portfolio
      positions_analytics
      share_sectors_pie
      calculate_total_stats
    end

    private

    def filter_positions
      @positions = @positions.where(portfolio: @portfolio)
    end

    def positions_analytics
      @positions_analytics = Analytics::PositionsService.call(positions: @positions).result
    end

    def share_sectors_pie
      @sector_pie_stats = Analytics::ShareSectorsService.call(stats: @positions_analytics.dig(:share, :stats)).result
    end

    def calculate_total_stats
      @positions_analytics[:total][:summary][:income_percent] = accumulated_income_percent
    end

    def accumulated_income_percent
      return 0 if initial_portfolio_cash.zero?

      (100.0 * @positions_analytics[:total][:summary][:income_cents] / initial_portfolio_cash).round(2)
    end

    def initial_portfolio_cash
      @initial_portfolio_cash ||=
        Portfolios::Cash.where(amount_currency: 'RUB', portfolio: @portfolio || @portfolios).sum(&:amount_cents)
    end
  end
end
