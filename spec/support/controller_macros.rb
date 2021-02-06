# frozen_string_literal: true

module ControllerMacros
  def sign_in_unconfirmed_user
    before do
      @current_user = create :user, :unconfirmed
      sign_in @current_user
    end
  end

  def sign_in_user
    before do
      @current_user = create :user
      sign_in @current_user
    end
  end
end
