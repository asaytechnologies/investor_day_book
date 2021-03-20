# frozen_string_literal: true

module Api
  module V1
    class PortfoliosController < Api::V1::BaseController
      before_action :find_portfolios, only: %i[index]
      before_action :find_portfolio, only: %i[destroy clear]

      def index
        render json: { portfolios: PortfolioSerializer.new(@portfolios).serializable_hash }, status: :ok
      end

      def create
        service = ::Portfolios::CreateService.call(portfolio_params.merge(user: Current.user))
        if service.result
          create_upload(service.result)
          render json: { portfolio: PortfolioSerializer.new(service.result).serializable_hash }, status: :created
        else
          render json: { errors: service.errors.full_messages }, status: :conflict
        end
      end

      def destroy
        @portfolio.destroy
        render json: { result: 'success' }, status: :ok
      end

      def clear
        @portfolio.positions.destroy_all
        render json: { result: 'success' }, status: :ok
      end

      private

      def find_portfolios
        @portfolios = Current.user.portfolios.order(created_at: :desc)
      end

      def find_portfolio
        @portfolio = Current.user.portfolios.find_by(id: params[:id])
      end

      def create_upload(uploadable)
        return unless params.dig(:upload, :file)

        uploadable.uploads.create(
          file: params.dig(:upload, :file),
          user: Current.user,
          name: 'portfolio_initial_data'
        )
      end

      def portfolio_params
        requets_params = params.require(:portfolio).permit(:name, :source, :currency).to_h.symbolize_keys
        requets_params[:source] = requets_params[:source].to_i == -1 ? nil : requets_params[:source].to_i
        requets_params[:currency] = requets_params[:currency].to_i
        requets_params
      end
    end
  end
end
