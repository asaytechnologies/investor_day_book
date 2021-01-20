# frozen_string_literal: true

class PortfoliosController < ApplicationController
  before_action :portfolios

  def index; end

  private

  def portfolios
    @portfolios = Portfolios::Fetching::ForAccountService.call(user: current_user).result.to_a
  end
end
