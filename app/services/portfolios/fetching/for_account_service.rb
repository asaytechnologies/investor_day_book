# frozen_string_literal: true

module Portfolios
  module Fetching
    class ForAccountService
      prepend BasicService

      def call(user:)
        @result =
          user
          .portfolios
          .order(id: :desc)
      end
    end
  end
end
