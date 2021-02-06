# frozen_string_literal: true

module Portfolios
  class CashesReflex < ApplicationReflex
    before_reflex :find_portfolio

    def create(args={})
      Portfolios::Cashes::IncomeChangeService.call(portfolio: @portfolio, cashes_params: cashes_params)

      current_locale(args['locale'])
      render_positions(args['portfolio_id'])
    end

    def update_balance(args={})
      Portfolios::Cashes::BalanceChangeService.call(portfolio: @portfolio, cashes_params: cashes_params)

      current_locale(args['locale'])
      render_positions(args['portfolio_id'])
    end

    private

    def render_positions(portfolio_id)
      portfolio = find_user_portfolio_for_render(portfolio_id)

      morph(
        '#positions',
        AnalyticsController.render(
          Analytics::PositionsComponent.new(
            current_user: current_user,
            portfolio:    portfolio
          )
        )
      )
    end

    def find_user_portfolio_for_render(portfolio_id)
      return if portfolio_id == '0'

      current_user.portfolios.find_by(id: portfolio_id)
    end

    def find_portfolio
      @portfolio = current_user.portfolios.find_by(id: params[:portfolio_id])
    end

    def cashes_params
      params.require(:portfolio).permit(:operation, :usd, :eur, :rub)
    end
  end
end
