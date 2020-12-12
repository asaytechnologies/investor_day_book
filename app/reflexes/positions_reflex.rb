# frozen_string_literal: true

class PositionsReflex < ApplicationReflex
  before_reflex :find_portfolio, only: [:create]
  before_reflex :find_quote, only: [:create]

  def index(portfolio_id='0', locale='en', plan=false)
    current_locale(locale)
    render_positions(current_user, portfolio_id, plan)
  end

  def create(portfolio_id='0', locale='en')
    create_position

    current_locale(locale)
    render_positions(current_user, portfolio_id, false)
    morph '#quotes', AnalyticsController.render(Analytics::QuotesComponent.new(quotes: []))
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

  def render_positions(current_user, portfolio_id, plan)
    portfolio = find_user_portfolio_for_render(portfolio_id)
    positions = Positions::Fetching::ForAnalyticsService.call(user: current_user).result

    morph(
      '#positions',
      AnalyticsController.render(
        Analytics::PositionsComponent.new(
          portfolios: current_user.portfolios,
          positions:  positions,
          portfolio:  portfolio,
          options:    { plan: plan }
        )
      )
    )
  end

  def position_params
    params.require(:position).permit(:portfolio_id, :quote_id, :price, :amount)
  end

  def operation_params
    params.require(:position).permit(:operation)
  end
end
