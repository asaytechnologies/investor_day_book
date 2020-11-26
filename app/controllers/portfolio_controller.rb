# frozen_string_literal: true

class PortfolioController < ApplicationController
  before_action :positions

  def index; end

  private

  def positions
    @positions = Positions::Fetching::ForPortfolioService.call(user: current_user).result
  end
end
