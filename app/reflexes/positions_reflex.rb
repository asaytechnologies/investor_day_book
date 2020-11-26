# frozen_string_literal: true

class PositionsReflex < ApplicationReflex
  before_reflex :find_portfolio, only: [:create]
  before_reflex :find_quote, only: [:create]

  def create
    create_position

    positions = current_user.positions.includes(quote: :security).order(id: :desc)

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
      amount:    position_money
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
end
