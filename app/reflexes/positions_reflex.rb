# frozen_string_literal: true

class PositionsReflex < ApplicationReflex
  before_reflex :find_portfolio, only: [:create]
  before_reflex :find_quote, only: [:create]

  def index(args={})
    current_locale(args['locale'])
    render_positions(args['portfolio_id'], args['show_plans'], args['show_dividents'])
  end

  def create(args={})
    create_position

    current_locale(args['locale'])
    render_positions(args['portfolio_id'], args['show_plans'], args['show_dividents'])
    morph '#quotes', AnalyticsController.render(Analytics::QuotesComponent.new(quotes: []))
  end

  def destroy(args={})
    destroy_position(args['position_id'])

    current_locale(args['locale'])
    render_positions(args['portfolio_id'], args['show_plans'], args['show_dividents'])
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
      portfolio:      @portfolio,
      quote:          @quote,
      price:          position_price,
      amount:         position_money,
      operation:      position_params[:operation],
      operation_date: position_params[:operation_date]
    )
  end

  def destroy_position(position_id)
    Positions::DestroyService.call(
      position_id: position_id,
      user:        current_user
    )
  end

  def position_price
    Money.new(position_params[:price].to_f * 100, @quote.price_currency)
  end

  def position_money
    position_params[:amount].to_i
  end

  def render_positions(portfolio_id, plan, dividents)
    portfolio = find_user_portfolio_for_render(portfolio_id)

    morph(
      '#positions',
      AnalyticsController.render(
        Analytics::PositionsComponent.new(
          current_user: current_user,
          portfolio:    portfolio,
          options:      { plan: plan == 'true', dividents: dividents == 'true' }
        )
      )
    )
  end

  def position_params
    params.require(:position).permit(:portfolio_id, :quote_id, :price, :amount, :operation, :operation_date)
  end
end
