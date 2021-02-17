# frozen_string_literal: true

class OperationsController < ApplicationController
  before_action :portfolios

  def index; end

  private

  def portfolios
    @portfolios = current_user.portfolios.order(id: :desc).to_a
  end
end
