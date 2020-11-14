# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    protected

    def after_sign_in_path_for(_resource)
      home_index_path
    end
  end
end
