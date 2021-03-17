# frozen_string_literal: true

module Api
  module V1
    module Users
      class PositionsController < Api::V1::BaseController
        before_action :find_positions, only: %i[index]
        before_action :find_portfolio, only: %i[create]
        before_action :find_quote, only: %i[create]

        def index
          render json: {
            positions: ::Users::PositionSerializer.new(
              @positions,
              { params: { fields: request_fields } }
            ).serializable_hash
          }, status: :ok
        end

        def create
          service = create_position
          if service.result
            render json: {
              position: ::Users::PositionSerializer.new(service.result).serializable_hash
            }, status: :created
          else
            render json: { errors: service.errors }, status: :conflict
          end
        end

        private

        def find_positions
          @positions = Current.user.positions.real.order(operation_date: :desc, id: :desc).includes(quote: :security)
          @positions = @positions.where(portfolio_id: params[:portfolio_id]) if params[:portfolio_id]
        end

        def find_portfolio
          @portfolio = Current.user.portfolios.find_by(id: position_params[:portfolio_id])
        end

        def find_quote
          @quote = Quote.find_by(id: position_params[:quote_id])
        end

        def create_position
          Positions::CreateService.call(
            portfolio:      @portfolio,
            quote:          @quote,
            price:          position_params[:price].to_f,
            price_currency: @quote&.price_currency,
            amount:         position_params[:amount].to_i,
            operation:      position_params[:operation],
            operation_date: position_params[:operation_date]
          )
        end

        def position_params
          params.require(:position).permit(:portfolio_id, :quote_id, :price, :amount, :operation, :operation_date)
        end
      end
    end
  end
end
