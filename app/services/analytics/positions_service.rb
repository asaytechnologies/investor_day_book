# frozen_string_literal: true

module Analytics
  class PositionsService
    prepend BasicService

    EXCHANGE_RATES = { RUB: 1, USD: 74.25, EUR: 90.26 }.freeze

    def initialize; end

    def call(positions:)
      @result = positions.group_by(&:quote).each_with_object(default_stats) do |(quote, positions), acc|
        perform_real_positions_calculation(quote, positions.reject(&:plan), acc)
        perform_plan_positions_calculation(quote, positions.select(&:plan).first, acc)
      end
    end

    private

    def perform_real_positions_calculation(quote, positions, acc)
      return if positions.empty?

      stats = perform_calculation(quote, positions)
      update_total_stats(acc, quote, stats)
      update_security_stats(acc, quote, stats)
    end

    def perform_plan_positions_calculation(quote, position, acc)
      return if position.nil?

      acc[security_symbol(quote)][:plans][quote] = {
        plan:                true,
        amount:              position.amount,
        price_cents:         position.price_cents,
        selling_total_cents: position.amount * position.price_cents
      }
    end

    def perform_calculation(quote, positions)
      calculate_basis_stats(positions)
        .then { |stats| calculate_selling_stats(quote, stats) }
    end

    def calculate_basis_stats(positions)
      positions.each_with_object(basis_stats) do |position, acc|
        next update_selling_stats(acc, position) if position.selling_position?

        update_buying_stats(acc, position)
      end
    end

    def update_selling_stats(acc, position)
      acc[:selling_sold_cents] += position.amount * position.price_cents
    end

    def update_buying_stats(acc, position)
      unsold_amount = position.amount - position.sold_amount
      acc[:unsold_amount]       += unsold_amount
      acc[:buying_unsold_cents] += unsold_amount * position.price_cents
      acc[:buying_total_cents]  += position.amount * position.price_cents
    end

    # rubocop: disable Metrics/AbcSize
    def calculate_selling_stats(quote, stats)
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

    def update_total_stats(acc, quote, stats)
      currency_symbol = quote_currency_symbol(quote)

      # acc[:total][currency_symbol][:total_cents]  += stats[:selling_total_cents]
      # acc[:total][currency_symbol][:income_cents] += stats[:selling_total_income_cents]
      acc[:total][:summary][:total_cents] += stats[:selling_total_cents] * EXCHANGE_RATES[currency_symbol]
      acc[:total][:summary][:income_cents] += stats[:selling_total_income_cents] * EXCHANGE_RATES[currency_symbol]
    end

    def update_security_stats(acc, quote, stats)
      acc[security_symbol(quote)][:stats][quote] = stats
    end

    def quote_currency_symbol(quote)
      quote.price_currency.to_sym
    end

    def security_symbol(quote)
      quote.security.type.downcase.to_sym
    end

    def default_stats
      {
        share:      { stats: {}, plans: {} },
        foundation: { stats: {}, plans: {} },
        bond:       { stats: {}, plans: {} },
        total:      {
          RUB:     { total_cents: 0, income_cents: 0 },
          USD:     { total_cents: 0, income_cents: 0 },
          EUR:     { total_cents: 0, income_cents: 0 },
          summary: { total_cents: 0, income_cents: 0 }
        }
      }
    end

    def basis_stats
      {
        unsold_amount:       0, # unsold amount of securities
        buying_unsold_cents: 0, # buying total price cents of unsold securities
        buying_total_cents:  0, # buying total price cents of all securities
        selling_sold_cents:  0 # selling total price cents of sold securities
      }
    end
  end
end