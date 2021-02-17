# frozen_string_literal: true

module Operations
  module Index
    class ListComponent < ViewComponent::Base
      include ViewHelper

      def initialize(current_user:)
        @current_user = current_user
        @positions = @current_user.positions.real.order(operation_date: :desc).includes(quote: :security)
      end
    end
  end
end
