# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :check_captcha, only: %i[create] # rubocop: disable Rails/LexicallyScopedActionFilter

    private

    def check_captcha
      redirect_to new_user_registration_path unless verify_recaptcha
    end

    protected

    def after_inactive_sign_up_path_for(resource)
      check_confirmations_path(email: resource.email)
    end
  end
end
