# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  prepend_view_path Rails.root.join('frontend')

  before_action :authenticate_user!
end
