# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  prepend_view_path Rails.root.join('frontend')

  before_action :authenticate_user!
  before_action :set_current_locale

  private

  def set_current_locale
    I18n.locale = params[:locale]
  end
end
