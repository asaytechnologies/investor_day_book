# frozen_string_literal: true

module Analytics
  class PositionsComponent < ViewComponent::Base
    include ViewHelper

    def initialize(current_user:, portfolio: nil, options: {})
      @portfolio_ids = portfolio ? [portfolio.id] : current_user.portfolios.ids
      @options       = options
      @user          = current_user

      find_exchange_rates
      balance_analytics
      positions_analytics
      actives_pie
      share_sectors_pie
      calculate_total_stats
    end

    private

    def find_exchange_rates
      @exchange_rates = Rails.cache.fetch('RUB_exchange_rates', expires_in: 4.hours) do
        rub_exchange_rates = ExchangeRate.where(rate_currency: 'RUB')
        {
          RUB: rub_exchange_rates.find { |e| e.base_currency == 'RUB' }.rate_amount,
          USD: rub_exchange_rates.find { |e| e.base_currency == 'USD' }.rate_amount,
          EUR: rub_exchange_rates.find { |e| e.base_currency == 'EUR' }.rate_amount
        }
      end
    end

    def balance_analytics
      @balance_analytics =
        Analytics::BalanceService.call(
          portfolio_ids:  @portfolio_ids,
          exchange_rates: @exchange_rates
        ).result
    end

    def positions_analytics
      @positions_analytics =
        Analytics::PositionsService.call(
          user:           @user,
          portfolio_ids:  @portfolio_ids,
          exchange_rates: @exchange_rates,
          options:        @options
        ).result
    end

    def actives_pie
      @actives_pie_stats =
        Analytics::ActivesService.call(
          currencies:  @balance_analytics[:summary_price],
          shares:      @positions_analytics[:share][:total_price],
          bonds:       @positions_analytics[:bond][:total_price],
          foundations: @positions_analytics[:foundation][:total_price]
        ).result
    end

    def share_sectors_pie
      @sector_pie_stats =
        Analytics::ShareSectorsService.call(
          stats:          @positions_analytics.dig(:share, :stats),
          plans:          @positions_analytics.dig(:share, :plans),
          exchange_rates: @exchange_rates
        ).result
    end

    # rubocop: disable Metrics/AbcSize
    def calculate_total_stats
      @positions_analytics[:total][:summary][:total_price] += @balance_analytics[:summary_price]
      @positions_analytics[:total][:summary][:total_income_price] = total_income_price
      @positions_analytics[:total][:summary][:income_percent] = accumulated_income_percent
      %i[share bond foundation].each do |key|
        profit = @positions_analytics[key][:total_price].round(2) - @positions_analytics[key][:total_buy_price].round(2)
        @positions_analytics[key][:total_profit] = profit
        @positions_analytics[key][:total_profit_percent] =
          @positions_analytics[key][:total_buy_price].zero? ? 0 : (100 * profit / @positions_analytics[key][:total_buy_price]).round(2)
      end
    end
    # rubocop: enable Metrics/AbcSize

    def total_income_price
      @positions_analytics[:total][:summary][:total_price] - initial_portfolio_cash
    end

    def accumulated_income_percent
      return 0 if initial_portfolio_cash.zero?

      (100.0 * @positions_analytics[:total][:summary][:total_income_price] / initial_portfolio_cash).round(2)
    end

    def initial_portfolio_cash
      @initial_portfolio_cash ||=
        Portfolios::Cash
        .where(amount_currency: 'RUB', portfolio: @portfolio_ids, balance: false)
        .sum(&:amount_cents) / 100
    end
  end
end
