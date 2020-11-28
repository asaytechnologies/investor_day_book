# frozen_string_literal: true

class PortfoliosReflex < ApplicationReflex
  def create(locale='en')
    create_portfolio

    portfolios = Portfolios::Fetching::ForAccountService.call(user: current_user).result

    current_locale(locale)
    morph '#portfolios', AccountController.render(Accounts::PortfoliosComponent.new(portfolios: portfolios))
  end

  private

  def create_portfolio
    Portfolios::CreateService.call(portfolio_params.merge(user: current_user))
  end

  def portfolio_params
    params.require(:portfolio).permit(:name)
  end
end
