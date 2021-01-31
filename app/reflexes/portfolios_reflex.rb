# frozen_string_literal: true

class PortfoliosReflex < ApplicationReflex
  def create(args={})
    create_portfolio(args['guid'])
    current_locale(args['locale'])
    render_portfolios
  end

  def destroy(args={})
    destroy_portfolio(args['portfolio_id'])
    current_locale(args['locale'])
    render_portfolios
  end

  def clear(args={})
    clear_portfolio(args['portfolio_id'])
    current_locale(args['locale'])
    render_portfolios
  end

  private

  def render_portfolios
    morph(
      '#portfolios',
      PortfoliosController.render(
        Portfolios::ListComponent.new(
          current_user: current_user
        )
      )
    )
  end

  def create_portfolio(guid)
    Portfolios::CreateService.call(portfolio_params.merge(user: current_user, guid: guid))
  end

  def destroy_portfolio(portfolio_id)
    Portfolios::DestroyService.call(user: current_user, id: portfolio_id)
  end

  def clear_portfolio(portfolio_id)
    Portfolios::ClearService.call(user: current_user, id: portfolio_id)
  end

  def portfolio_params
    requets_params = params.require(:portfolio).permit(:name, :source, :currency).to_h.symbolize_keys
    requets_params[:source] = requets_params[:source] == '-1' ? nil : requets_params[:source].to_i
    requets_params[:currency] = requets_params[:currency].to_i
    requets_params
  end
end
