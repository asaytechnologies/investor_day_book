# frozen_string_literal: true

module Api
  module V1
    class AnalyticsController < Api::V1::BaseController
      before_action :find_portfolio, only: %i[index]
      before_action :perform_analytics, only: %i[index]

      def index
        render json: {
          balance_analytics: @analytics.balance_analytics,
          positions:         @analytics.positions,
          actives_pie_stats: @analytics.actives_pie_stats,
          sector_pie_stats:  @analytics.sector_pie_stats
        }, status: :ok
      end

      private

      def find_portfolio
        return unless params[:portfolio_id]

        @portfolio = Current.user.portfolios.find_by(id: params[:portfolio_id])
      end

      def perform_analytics
        @analytics = Analytics::PerformService.call(user: Current.user, portfolio: @portfolio)
      end
    end
  end
end
