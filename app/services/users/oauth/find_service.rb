# frozen_string_literal: true

module Users
  module Oauth
    class FindService
      prepend BasicService

      def call(auth:)
        @auth = auth

        find_user_by_identity
        return if @result.present?
        return if email.nil?

        ActiveRecord::Base.transaction do
          find_or_create_user
          create_identity
          @result = @user
        end
      end

      private

      def find_user_by_identity
        @result = Identity.find_with_oauth(@auth)&.user
      end

      def email
        @email ||= @auth.info['email'].downcase
      end

      def find_or_create_user
        @user = User.find_by(email: email)
        return if @user.present?

        @user = User.create!(email: email, password: Devise.friendly_token[0, 20], confirmed_at: DateTime.now)
      end

      def create_identity
        @user.identities.create!(provider: @auth.provider, uid: @auth.uid)
      end
    end
  end
end
