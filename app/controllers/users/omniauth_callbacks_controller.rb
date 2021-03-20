# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :authenticate_user!
    skip_before_action :current_locale
    before_action :restore_locale
    before_action :perform_authentication

    def google_oauth2; end

    def vkontakte; end

    private

    def restore_locale
      I18n.locale = cookies[:invest_plan_locale] || I18n.default_locale
    end

    def perform_authentication
      auth = request.env['omniauth.auth']
      return redirect_to root_path, flash: { error: 'Access Error' } if auth.nil?

      user = Users::Oauth::FindService.call(auth: auth).result
      if user
        sign_in user
        redirect_to analytics_path
      else
        redirect_to root_path, flash: { manifesto_username: true }
      end
    end
  end
end
