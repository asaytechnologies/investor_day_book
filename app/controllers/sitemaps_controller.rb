# frozen_string_literal: true

class SitemapsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :current_locale

  def index; end
end
