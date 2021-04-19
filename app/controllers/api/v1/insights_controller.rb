# frozen_string_literal: true

module Api
  module V1
    class InsightsController < Api::V1::BaseController
      before_action :find_portfolio, only: %i[index]
      before_action :find_insights, only: %i[index]

      def index
        render json: { insights: InsightSerializer.new(@insights).serializable_hash }, status: :ok
      end

      private

      def find_portfolio
        return unless params[:portfolio_id]

        @portfolio = Current.user.portfolios.find_by(id: params[:portfolio_id])
      end

      def find_insights
        @insights = Insight.where(parentable: @portfolio || Current.user)
      end
    end
  end
end
