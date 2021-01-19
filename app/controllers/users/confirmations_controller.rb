# frozen_string_literal: true

module Users
  class ConfirmationsController < Devise::ConfirmationsController
    def check; end
  end
end
