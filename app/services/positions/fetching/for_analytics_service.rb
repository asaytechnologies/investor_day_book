# frozen_string_literal: true

module Positions
  module Fetching
    class ForAnalyticsService
      def call(user:)
        user
          .positions
          .order(id: :desc)
          .includes(quote: [security: :sector])
      end
    end
  end
end
