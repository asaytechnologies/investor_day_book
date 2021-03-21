# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      class AuthFailure < StandardError; end

      protect_from_forgery with: :null_session

      skip_before_action :authenticate_user!
      skip_before_action :current_locale
      skip_before_action :set_current_user
      before_action :authenticate
      before_action :set_locale

      private

      def set_locale
        I18n.locale = params[:locale] || I18n.default_locale
      end

      def authenticate
        auto_auth
      rescue AuthFailure => e
        Current.user = nil
        render json: { errors: e.message }, status: :unauthorized
      end

      def auto_auth
        return user_auth(params[:access_token]) if params[:access_token].present?

        raise AuthFailure, 'There is no authorization token'
      end

      def user_auth(access_token)
        check_token(access_token)
        find_user
        check_confirmation
        Current.user = @user
      end

      def check_token(access_token)
        @identifier = JwtService.new.decode(access_token: access_token)['user_id']
      rescue StandardError
        raise AuthFailure, 'Signature verification error'
      end

      def find_user
        @user = User.find_by(id: @identifier)
        raise AuthFailure, 'Authorization error' if @user.nil?
      end

      def check_confirmation
        raise AuthFailure, 'Your email is not confirmed' unless @user.confirmed?
      end

      def request_fields
        return if params[:fields].blank?

        params[:fields].split(',')
      end

      def render_not_found_error
        render json: { errors: [t('errors.object_not_found')] }, status: :not_found
      end
    end
  end
end
