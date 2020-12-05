# frozen_string_literal: true

module Analytics
  class PositionsComponent < ViewComponent::Base
    def initialize(portfolios:, positions:, portfolio: nil)
      @portfolios = portfolios
      @positions  = positions
      @portfolio  = portfolio

      filter_positions if @portfolio
      prepare_portfolio_stats
      calculate_total_stats
    end

    private

    def filter_positions
      @positions = @positions.where(portfolio: @portfolio)
    end

    # rubocop: disable Metrics/AbcSize
    def prepare_portfolio_stats
      @portfolio_stats = @positions.group_by(&:quote).each_with_object(basis_stats) do |(quote, positions), acc|
        stats = perform_positions_stats_calculation(quote, positions)

        acc['Total'][quote.price_currency][:total_cents]  += stats[:selling_total_cents]
        acc['Total'][quote.price_currency][:income_cents] += stats[:selling_total_income_cents]

        acc[quote.security.type][:elements][quote] = stats
      end
    end
    # rubocop: enable Metrics/AbcSize

    def calculate_total_stats
      @portfolio_stats['Total'].slice('RUB', 'USD', 'EUR').each_value do |values|
        @portfolio_stats['Total']['ACCUMULATE'][:income_cents] += values[:income_cents] * values[:exchange_rate]
      end

      @portfolio_stats['Total']['ACCUMULATE'][:income_percent] = accumulated_income_percent
    end

    def accumulated_income_percent
      return 0 if initial_portfolio_cash.zero?

      (100.0 * @portfolio_stats['Total']['ACCUMULATE'][:income_cents] / initial_portfolio_cash).round(2)
    end

    def initial_portfolio_cash
      @initial_portfolio_cash ||=
        Portfolios::Cash.where(amount_currency: 'RUB', portfolio: @portfolio || @portfolios).sum(&:amount_cents)
    end

    def basis_stats
      {
        'Total'      => {
          'RUB'        => { total_cents: 0, income_cents: 0, exchange_rate: 1 },
          'USD'        => { total_cents: 0, income_cents: 0, exchange_rate: 74.25 },
          'EUR'        => { total_cents: 0, income_cents: 0, exchange_rate: 90.26 },
          'ACCUMULATE' => { income_cents: 0, income_percent: 0 }
        },
        'Share'      => { name: t('analytics.table.shares_name'), elements: {} },
        'Foundation' => { name: t('analytics.table.foundations_name'), elements: {} },
        'Bond'       => { name: t('analytics.table.bonds_name'), elements: {} }
      }
    end

    def perform_positions_stats_calculation(quote, positions)
      calculate_positions_stats(positions)
        .then { |stats| calculate_positions_selling_stats(quote, stats) }
    end

    # rubocop: disable Metrics/AbcSize
    def calculate_positions_stats(positions)
      positions.each_with_object(basis_positions_stats) do |position, acc|
        if position.selling_position?
          acc[:selling_sold_cents] += position.amount * position.price_cents
        else
          unsold_amount = position.amount - position.sold_amount
          acc[:unsold_amount]       += unsold_amount
          acc[:buying_unsold_cents] += unsold_amount * position.price_cents
          acc[:buying_total_cents]  += position.amount * position.price_cents
        end
      end
    end

    def basis_positions_stats
      {
        unsold_amount:       0, # unsold amount of securities
        buying_unsold_cents: 0, # buying total price cents of unsold securities
        buying_total_cents:  0, # buying total price cents of all securities
        selling_sold_cents:  0 # selling total price cents of sold securities
      }
    end

    def calculate_positions_selling_stats(quote, stats)
      # selling price for unsold securities
      selling_unsold_cents = quote.price_cents * stats[:unsold_amount]
      # selling price for unsold securities + selling price for sold securities
      selling_total_cents  = selling_unsold_cents + stats[:selling_sold_cents]
      # selling price for unsold securities + selling price for sold securities - buying price for all securities
      selling_total_income_cents  = selling_total_cents - stats[:buying_total_cents]
      # difference between selling and buying price of unsold securities
      selling_unsold_income_cents = selling_unsold_cents - stats[:buying_unsold_cents]
      # average prices
      buying_unsold_average_cents =
        stats[:unsold_amount].zero? ? 0 : (stats[:buying_unsold_cents].to_f / stats[:unsold_amount])
      exchange_profit =
        buying_unsold_average_cents.zero? ? 0 : ((quote.price_cents / buying_unsold_average_cents - 1) * 100).round(2)

      stats.merge(
        selling_unsold_cents:        selling_unsold_cents,
        selling_total_cents:         selling_total_cents,
        selling_total_income_cents:  selling_total_income_cents,
        selling_unsold_income_cents: selling_unsold_income_cents,
        buying_unsold_average_cents: buying_unsold_average_cents,
        exchange_profit:             exchange_profit
      )
    end
    # rubocop: enable Metrics/AbcSize
  end
end
