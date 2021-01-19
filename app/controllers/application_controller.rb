# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  prepend_view_path Rails.root.join('frontend')

  before_action :authenticate_user!
  before_action :current_locale

  private

  def current_locale
    I18n.locale = cookies[:invest_plan_locale] = params[:locale]
  end
end
