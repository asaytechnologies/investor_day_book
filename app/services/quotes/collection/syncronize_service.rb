# frozen_string_literal: true

module Quotes
  module Collection
    class SyncronizeService
      prepend BasicService

      def initialize(
        fetch_service: FetchService,
        save_service:  SaveService
      )
        @fetch_service = fetch_service
        @save_service  = save_service
      end

      def call(source:, date:)
        @source = source
        @date   = date

        fetch_quotes
          .then { |elements| save_quotes(elements) }
      end

      private

      def fetch_quotes
        @fetch_service
          .call(source: @source, date: @date)
          .result
      end

      def save_quotes(quotes)
        @save_service
          .call(quotes: quotes, source: @source)
      end
    end
  end
end
