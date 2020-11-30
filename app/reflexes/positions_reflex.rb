# frozen_string_literal: true

class PositionsReflex < ApplicationReflex
  before_reflex :find_portfolio, only: [:create]
  before_reflex :find_quote, only: [:create]

  def index(portfolio_id='0', locale='en')
    portfolio = find_user_portfolio_for_render(portfolio_id)
    positions = Positions::Fetching::ForPortfolioService.call(user: current_user).result

    current_locale(locale)
    morph(
      '#positions',
      AnalyticsController.render(Analytics::PositionsComponent.new(positions: positions, portfolio: portfolio))
    )
  end

  def create(portfolio_id='0', locale='en')
    create_position

    portfolio = find_user_portfolio_for_render(portfolio_id)
    positions = Positions::Fetching::ForPortfolioService.call(user: current_user).result

    current_locale(locale)
    morph '#quotes', AnalyticsController.render(Analytics::QuotesComponent.new(quotes: []))
    morph(
      '#positions',
      AnalyticsController.render(Analytics::PositionsComponent.new(positions: positions, portfolio: portfolio))
    )
  end

  private

  def find_user_portfolio_for_render(portfolio_id)
    return if portfolio_id == '0'

    current_user.portfolios.find_by(id: portfolio_id)
  end

  def find_portfolio
    @portfolio = current_user.portfolios.find_by(id: position_params[:portfolio_id])
  end

  def find_quote
    @quote = Quote.find_by(id: position_params[:quote_id])
  end

  def create_position
    Positions::CreateService.call(
      portfolio: @portfolio,
      quote:     @quote,
      price:     position_price,
      amount:    position_money,
      operation: operation_params[:operation]
    )
  end

  def position_price
    Money.new(position_params[:price].to_f * 100, @quote.price_currency)
  end

  def position_money
    position_params[:amount].to_i
  end

  def position_params
    params.require(:position).permit(:portfolio_id, :quote_id, :price, :amount)
  end

  def operation_params
    params.require(:position).permit(:operation)
  end
end
