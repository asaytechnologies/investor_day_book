# frozen_string_literal: true

class PortfolioController < ApplicationController
  before_action :positions

  def index; end

  private

  def positions
    @positions = current_user.positions.includes(quote: :security).order(id: :desc)
  end
end
