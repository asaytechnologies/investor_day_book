# frozen_string_literal: true

module Analytics
  class PerformService
    prepend BasicService

    attr_reader :balance_analytics, :positions, :actives_pie_stats, :sector_pie_stats

    def initialize(
      balance_service:       Performing::BalanceService,
      positions_service:     Performing::PositionsService,
      actives_service:       Performing::ActivesService,
      share_sectors_service: Performing::ShareSectorsService
    )
      @balance_service       = balance_service
      @positions_service     = positions_service
      @actives_service       = actives_service
      @share_sectors_service = share_sectors_service
    end

    def call(user:, portfolio: nil, options: {})
      @portfolio_ids = portfolio ? [portfolio.id] : user.portfolios.ids
      @options       = options
      @user          = user

      find_exchange_rates
      perform_balance_analytics
      perform_positions_analytics
      perform_actives_pie
      perform_share_sectors_pie
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

    def perform_balance_analytics
      @balance_analytics =
        @balance_service.call(
          portfolio_ids:  @portfolio_ids,
          exchange_rates: @exchange_rates
        ).result
    end

    def perform_positions_analytics
      @positions =
        @positions_service.call(
          user:           @user,
          portfolio_ids:  @portfolio_ids,
          exchange_rates: @exchange_rates,
          options:        @options
        ).result
    end

    def perform_actives_pie
      @actives_pie_stats =
        @actives_service.call(
          currencies:  @balance_analytics[:summary_price],
          shares:      @positions[:share][:total][:price],
          bonds:       @positions[:bond][:total][:price],
          foundations: @positions[:foundation][:total][:price]
        ).result
    end

    def perform_share_sectors_pie
      @sector_pie_stats =
        @share_sectors_service.call(
          stats:          @positions.dig(:share, :stats),
          plans:          @positions.dig(:share, :plans),
          exchange_rates: @exchange_rates
        ).result
    end

    # rubocop: disable Metrics/AbcSize
    def calculate_total_stats
      @positions[:total][:summary][:price] += @balance_analytics[:summary_price]
      @positions[:total][:summary][:income_price] = total_income_price
      @positions[:total][:summary][:income_percent] = accumulated_income_percent
      %i[share bond foundation].each do |key|
        profit = @positions[key][:total][:price].round(2) - @positions[key][:total][:buy_price].round(2)
        @positions[key][:total][:profit] = profit
        @positions[key][:total][:profit_percent] =
          @positions[key][:total][:buy_price].zero? ? 0 : (100 * profit / @positions[key][:total][:buy_price]).round(2)
      end
    end
    # rubocop: enable Metrics/AbcSize

    def total_income_price
      @positions[:total][:summary][:price] - initial_portfolio_cash
    end

    def accumulated_income_percent
      return 0 if initial_portfolio_cash.zero?

      (100.0 * @positions[:total][:summary][:income_price] / initial_portfolio_cash).round(2)
    end

    def initial_portfolio_cash
      @initial_portfolio_cash ||=
        Portfolios::Cash
        .where(amount_currency: 'RUB', portfolio: @portfolio_ids, balance: false)
        .sum(&:amount_cents) / 100
    end
  end
end
