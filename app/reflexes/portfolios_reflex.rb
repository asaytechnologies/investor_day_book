# frozen_string_literal: true

class PortfoliosReflex < ApplicationReflex
  def create(args={})
    create_portfolio(args['guid'])

    @portfolios = Portfolios::Fetching::ForAccountService.call(user: current_user).result

    current_locale(args['locale'])
  end

  private

  def create_portfolio(guid)
    Portfolios::CreateService.call(portfolio_params.merge(user: current_user, guid: guid))
  end

  def portfolio_params
    params.require(:portfolio).permit(:name)
  end
end
