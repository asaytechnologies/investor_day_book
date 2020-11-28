# frozen_string_literal: true

module Positions
  module Fetching
    class ForPortfolioService
      prepend BasicService

      def call(user:)
        @result =
          user
          .positions
          .buying
          .with_unsold_securities
          .order(id: :desc)
          .includes(quote: :security)
      end
    end
  end
end