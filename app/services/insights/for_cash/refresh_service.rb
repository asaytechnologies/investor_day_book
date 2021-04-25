# frozen_string_literal: true

module Insights
  module ForCash
    class RefreshService
      prepend BasicService

      def call(parentable:, plan: false)
        @parentable  = parentable
        @plan        = plan

        @parentable.cashes.balance.each { |cash| update_cash_insights(cash) }
        update_active_type_insights
        @parentable.user.cashes.balance.each { |cash| update_cash_insights_for_user(cash) }
        update_active_type_insights_for_user
      end

      private

      def update_cash_insights(cash)
        insight = Insight.find_or_initialize_by(parentable: @parentable, insightable: cash, plan: @plan)
        insight.update(stats: { price: cash.amount_cents / 100.0 }, currency: cash.amount_currency)
      end

      def update_active_type_insights
        active_type = ActiveType.find_by(name: active_type_value)
        insight = Insight.find_or_initialize_by(parentable: @parentable, insightable: active_type, plan: @plan)
        Insight
          .where(parentable: @parentable, insightable: @parentable.cashes.balance, plan: @plan)
          .then { |insights| update_insight_stats(insight, insights) }
      end

      def update_cash_insights_for_user(cash)
        insight = Insight.find_or_initialize_by(parentable: user, insightable: cash, plan: @plan)
        cashes = Portfolios::Cash.where(cashable: user.portfolios, amount_currency: cash.amount_currency).balance
        insights = Insight.where(parentable: user.portfolios, insightable: cashes, plan: @plan)
        insight.update(stats: { price: insights.pluck(:stats).map { |e| e.symbolize_keys[:price] }.sum }, currency: cash.amount_currency)
      end

      def update_active_type_insights_for_user
        active_type = ActiveType.find_by(name: active_type_value)
        insight = Insight.find_or_initialize_by(parentable: user, insightable: active_type, plan: @plan)
        Insight
          .where(parentable: user.portfolios, insightable: active_type, plan: @plan)
          .then { |insights| update_insight_stats(insight, insights) }
      end

      def update_insight_stats(insight, insights)
        calculate_insights_summary(insights)
          .then { |stats| stats.transform_values!(&:to_f) }
          .then { |stats| insight.update(stats: stats, currency: 'RUB') }
      end

      def calculate_insights_summary(insights)
        insights.each_with_object({ price: 0 }) do |insight, acc|
          stats = insight.stats.symbolize_keys
          acc[:price] += stats[:price] * exchange_rates[insight.currency.to_sym]
        end
      end

      def exchange_rates
        @exchange_rates ||=
          Rails.cache.fetch('RUB_exchange_rates', expires_in: 4.hours) do
            rub_exchange_rates = ExchangeRate.where(rate_currency: 'RUB')
            {
              RUB: rub_exchange_rates.find { |e| e.base_currency == 'RUB' }.rate_amount,
              USD: rub_exchange_rates.find { |e| e.base_currency == 'USD' }.rate_amount,
              EUR: rub_exchange_rates.find { |e| e.base_currency == 'EUR' }.rate_amount
            }
          end
      end

      def active_type_value
        @active_type_value ||= 'Portfolios::Cash'
      end

      def user
        @user ||= @parentable.user
      end
    end
  end
end
