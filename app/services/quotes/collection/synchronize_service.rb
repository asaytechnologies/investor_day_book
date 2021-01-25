# frozen_string_literal: true

module Quotes
  module Collection
    class SynchronizeService
      prepend BasicService

      def initialize(
        fetch_service: FetchService,
        save_service:  SaveService
      )
        @fetch_service = fetch_service
        @save_service  = save_service
      end

      def call(source:, date: nil)
        @source = source
        @date   = date

        fetch_data
          .then { |data| save_data(data) }
      end

      private

      def fetch_data
        @fetch_service
          .call(source: @source, date: @date)
          .result
      end

      def save_data(data)
        @save_service
          .call(data: data, source: @source)
      end
    end
  end
end
