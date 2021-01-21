# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  prepend_view_path Rails.root.join('frontend')

  before_action :authenticate_user!, except: %i[catch_route_error]
  before_action :current_locale, except: %i[catch_route_error]

  def catch_route_error
    request.format = :html if request.format != :json
    render_error(t('errors.route_not_found'), 404)
  end

  private

  def current_locale
    I18n.locale = cookies[:invest_plan_locale] = params[:locale]
  end

  def render_error(message='Error', status=400)
    respond_to do |type|
      type.html { render_html_error(message) }
      type.json { render_json_error(message, status) }
    end
  end

  def render_json_error(message='Error', status=400)
    render json: { error: message }, status: status
  end

  def render_html_error(message='Error')
    @message = message
    render template: 'shared/404', status: :not_found
  end
end
