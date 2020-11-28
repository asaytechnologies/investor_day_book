# frozen_string_literal: true

class PositionsReflex < ApplicationReflex
  before_reflex :find_portfolio, only: [:create]
  before_reflex :find_quote, only: [:create]

  def create(locale = 'en')
    create_position

    set_locale(locale)
    positions = Positions::Fetching::ForPortfolioService.call(user: current_user).result

    morph '#quotes', PortfolioController.render(Portfolios::QuotesComponent.new(quotes: []))
    morph '#positions', PortfolioController.render(Portfolios::PositionsComponent.new(positions: positions))
  end

  private

  def find_portfolio
    @portfolio = Portfolio.find_or_create_by(user: current_user)
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
    params.require(:position).permit(:quote_id, :price, :amount)
  end

  def operation_params
    params.require(:position).permit(:operation)
  end
end
