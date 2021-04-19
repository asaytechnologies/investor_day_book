# frozen_string_literal: true

module Insights
  class RefreshService
    prepend BasicService

    def call(parentable:, insightable:, plan: false)
      @parentable  = parentable
      @insightable = insightable
      @plan        = plan

      update_quote_insights
      update_sectors_insights if @insightable.security.is_a?(Share) && sector.present?
      update_active_type_insights
      update_quote_insights_for_user
      update_sectors_insights_for_user if @insightable.security.is_a?(Share) && sector.present?
      update_active_type_insights_for_user
    end

    private

    def quote_positions
      @quote_positions ||=
        Users::Position
        .where(portfolio_id: @parentable.id, quote_id: @insightable.id, plan: @plan)
        .buying
        .with_unsold_securities
    end

    def quote
      @quote ||= Quote.find(@insightable.id)
    end

    def update_quote_insights
      insight = Insight.find_or_initialize_by(parentable: @parentable, insightable: @insightable, plan: @plan)
      calculate_basis_stats
        .then { |stats| calculate_average_stats(stats) }
        .then { |stats| stats.transform_values!(&:to_f) }
        .then { |stats| insight.update(stats: stats) }
    end

    def update_sectors_insights
      insight = Insight.find_or_initialize_by(parentable: @parentable, insightable: sector, plan: @plan)
      Insight
        .where(parentable: @parentable, insightable: sector.quotes, plan: @plan)
        .then { |insights| update_insight_stats(insight, insights) }
    end

    def update_active_type_insights
      active_type = ActiveType.find_by(name: active_type_value)
      active_type_quotes = Quote.joins(:security).where(securities: { type: active_type_value })
      insight = Insight.find_or_initialize_by(parentable: @parentable, insightable: active_type, plan: @plan)
      Insight
        .where(parentable: @parentable, insightable: active_type_quotes, plan: @plan)
        .then { |insights| update_insight_stats(insight, insights) }
    end

    def update_quote_insights_for_user
      insight = Insight.find_or_initialize_by(parentable: user, insightable: @insightable, plan: @plan)
      Insight
        .where(parentable: user.portfolios, insightable: @insightable, plan: @plan)
        .then { |insights| update_insight_stats(insight, insights) }
    end

    def update_sectors_insights_for_user
      insight = Insight.find_or_initialize_by(parentable: user, insightable: sector, plan: @plan)
      Insight
        .where(parentable: user.portfolios, insightable: sector.quotes, plan: @plan)
        .then { |insights| update_insight_stats(insight, insights) }
    end

    def update_active_type_insights_for_user
      active_type = ActiveType.find_by(name: active_type_value)
      active_type_quotes = Quote.joins(:security).where(securities: { type: active_type_value })
      insight = Insight.find_or_initialize_by(parentable: user, insightable: active_type, plan: @plan)
      Insight
        .where(parentable: user.portfolios, insightable: active_type_quotes, plan: @plan)
        .then { |insights| update_insight_stats(insight, insights) }
    end

    def update_insight_stats(insight, insights)
      calculate_insights_summary(insights)
        .then { |stats| stats.transform_values!(&:to_f) }
        .then { |stats| insight.update(stats: stats) }
    end

    def calculate_basis_stats
      quote_positions.each_with_object({ unsold_amount: 0, buying_unsold_price: 0 }) do |position, acc|
        unsold_amount = position.amount - position.sold_amount
        acc[:unsold_amount]       += unsold_amount
        acc[:buying_unsold_price] += unsold_amount * position.price
      end
    end

    def calculate_average_stats(stats)
      # selling price for unsold securities
      stats[:selling_unsold_price] = quote.price * stats[:unsold_amount]
      # difference between selling and buying price of unsold securities
      stats[:selling_unsold_income_price] = stats[:selling_unsold_price] - stats[:buying_unsold_price]
      # average prices
      stats[:buying_unsold_average_price] =
        stats[:unsold_amount].zero? ? 0 : (stats[:buying_unsold_price].to_f / stats[:unsold_amount]).round(4)
      stats[:exchange_profit] =
        stats[:buying_unsold_price].zero? ? 0 : ((stats[:selling_unsold_income_price] / stats[:buying_unsold_price]) * 100).round(2)
      # dividents
      stats[:dividents_amount_price] = dividents_amount_price(quote, stats[:unsold_amount])
      stats
    end

    def calculate_insights_summary(insights)
      insights.each_with_object({ buy_price: 0, price: 0, dividents: 0 }) do |insight, acc|
        stats = insight.stats.symbolize_keys
        acc[:buy_price] += stats[:buying_unsold_price] * exchange_rate
        acc[:price] += stats[:selling_unsold_price] * exchange_rate
        acc[:dividents] += stats[:dividents_amount_price] * exchange_rate
      end
    end

    def dividents_amount_price(quote, unsold_amount)
      return (quote.average_year_dividents_amount.to_f * unsold_amount).round(2) if quote.security.is_a?(Share)
      return 0 if quote.security.is_a?(Foundation)

      quote.coupons_sum_for_time_range * unsold_amount
    end

    def exchange_rate
      @exchange_rate ||= exchange_rates[currency_symbol]
    end

    def exchange_rates
      Rails.cache.fetch('RUB_exchange_rates', expires_in: 4.hours) do
        rub_exchange_rates = ExchangeRate.where(rate_currency: 'RUB')
        {
          RUB: rub_exchange_rates.find { |e| e.base_currency == 'RUB' }.rate_amount,
          USD: rub_exchange_rates.find { |e| e.base_currency == 'USD' }.rate_amount,
          EUR: rub_exchange_rates.find { |e| e.base_currency == 'EUR' }.rate_amount
        }
      end
    end

    def currency_symbol
      @insightable.price_currency.to_sym
    end

    def sector
      @sector ||= @insightable.security.sector
    end

    def active_type_value
      @active_type_value ||= @insightable.security.type
    end

    def user
      @user ||= @parentable.user
    end
  end
end
