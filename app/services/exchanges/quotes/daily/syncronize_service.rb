# frozen_string_literal: true

module Exchanges
  module Quotes
    module Daily
      class SyncronizeService
        prepend BasicService

        def initialize(
          exchanges_quotes_fetch_service: FetchService,
          exchanges_quotes_save_service:  SaveService
        )
          @exchanges_quotes_fetch_service = exchanges_quotes_fetch_service
          @exchanges_quotes_save_service  = exchanges_quotes_save_service
        end

        def call(source:, date:)
          @source = source
          @date   = date

          fetch_exchanges_quotes
            .then(&method(:save_exchanges_quotes))
        end

        private

        def fetch_exchanges_quotes
          @exchanges_quotes_fetch_service
            .call(source: @source, date: @date)
            .result
        end

        def save_exchanges_quotes(exchanges_quotes)
          @exchanges_quotes_save_service
            .call(exchanges_quotes: exchanges_quotes, source: @source)
        end
      end
    end
  end
end
