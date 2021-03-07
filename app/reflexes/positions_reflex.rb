# frozen_string_literal: true

class PositionsReflex < ApplicationReflex
  def index(args={})
    current_locale(args['locale'])
    render_positions(args['portfolio_id'])
  end

  def destroy(args={})
    destroy_position(args['position_id'])

    current_locale(args['locale'])
    render_positions(args['portfolio_id'])
  end

  private

  def find_user_portfolio_for_render(portfolio_id)
    return if portfolio_id == '0'

    current_user.portfolios.find_by(id: portfolio_id)
  end

  def destroy_position(position_id)
    Positions::DestroyService.call(
      position_id: position_id,
      user:        current_user
    )
  end

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
end
