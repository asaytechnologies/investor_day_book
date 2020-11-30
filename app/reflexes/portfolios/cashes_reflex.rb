# frozen_string_literal: true

module Portfolios
  class CashesReflex < ApplicationReflex
    before_reflex :find_portfolio, only: [:create]

    def create(_locale='en')
      morph(
        "#portfolio_#{@portfolio.id}",
        PortfoliosController.render(Portfolios::ListComponent.new(portfolio: @portfolio))
      )
    end

    private

    def find_portfolio
      @portfolio = current_user.portfolios.find_by(id: params[:portfolio_id])
    end

    def cashes_params
      params.require(:portfolio).permit(:operation, :usd, :eur, :rub)
    end
  end
end
