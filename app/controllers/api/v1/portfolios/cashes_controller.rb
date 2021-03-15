# frozen_string_literal: true

module Api
  module V1
    module Portfolios
      class CashesController < Api::V1::BaseController
        before_action :find_portfolio, only: %i[update]

        def update
          service = ::Portfolios::Cashes::ChangeService.call(
            portfolio:     @portfolio,
            scope:         params[:portfolio][:scope],
            cashes_params: cashes_params
          )
          if service.success?
            render json: {}, status: :ok
          else
            render json: { errors: service.errors.full_messages }, status: :conflict
          end
        end

        private

        def find_portfolio
          @portfolio = Current.user.portfolios.find_by(id: params[:id])
        end

        def cashes_params
          params.require(:portfolio).permit(:operation, :usd, :eur, :rub)
        end
      end
    end
  end
end
