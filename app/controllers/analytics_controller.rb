# frozen_string_literal: true

class AnalyticsController < ApplicationController
  before_action :portfolios

  def index; end

  private

  def portfolios
    @portfolios = current_user.portfolios
    @first_portfolio_cashes = @portfolios.first&.cashes&.balance
  end
end
