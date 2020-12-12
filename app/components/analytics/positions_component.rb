# frozen_string_literal: true

module Analytics
  class PositionsComponent < ViewComponent::Base
    include ViewHelper

    def initialize(portfolios:, positions:, portfolio: nil, options: {})
      @portfolios = portfolios
      @positions  = positions
      @portfolio  = portfolio
      @options    = options

      filter_positions
      balance_analytics
      positions_analytics
      actives_pie
      share_sectors_pie
      calculate_total_stats
    end

    private

    def filter_positions
      @positions = @positions.where(portfolio: @portfolio) if @portfolio
      @positions = @positions.real unless @options[:plan]
    end

    def balance_analytics
      @balance_analytics = Analytics::BalanceService.call(portfolios: @portfolio ? [@portfolio] : @portfolios).result
    end

    def positions_analytics
      @positions_analytics = Analytics::PositionsService.call(positions: @positions).result
    end

    def actives_pie
      @actives_pie_stats =
        Analytics::ActivesService.call(
          currencies:  @balance_analytics[:summary_cents],
          shares:      @positions_analytics[:share][:total_cents],
          bonds:       @positions_analytics[:bond][:total_cents],
          foundations: @positions_analytics[:foundation][:total_cents]
        ).result
    end

    def share_sectors_pie
      @sector_pie_stats =
        Analytics::ShareSectorsService.call(
          stats: @positions_analytics.dig(:share, :stats),
          plans: @positions_analytics.dig(:share, :plans)
        ).result
    end

    def calculate_total_stats
      @positions_analytics[:total][:summary][:income_percent] = accumulated_income_percent
    end

    def accumulated_income_percent
      return 0 if initial_portfolio_cash.zero?

      total_income_cents = @positions_analytics[:total][:summary][:income_cents] + @balance_analytics[:summary_cents]
      (100.0 * total_income_cents / initial_portfolio_cash).round(2)
    end

    def initial_portfolio_cash
      @initial_portfolio_cash ||=
        Portfolios::Cash.where(amount_currency: 'RUB', portfolio: @portfolio || @portfolios).sum(&:amount_cents)
    end
  end
end
