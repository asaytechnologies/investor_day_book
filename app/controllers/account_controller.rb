# frozen_string_literal: true

class AccountController < ApplicationController
  before_action :portfolios

  def index; end

  private

  def portfolios
    @portfolios = Portfolios::Fetching::ForAccountService.call(user: current_user).result
  end
end
