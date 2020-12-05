# frozen_string_literal: true

module Quotes
  module Collection
    class FetchService
      prepend BasicService

      def initialize(
        from_moex_service:    Fetching::MoexService,
        from_tinkoff_service: Fetching::TinkoffService
      )
        @from_moex_service    = from_moex_service
        @from_tinkoff_service = from_tinkoff_service
      end

      def call(source:, date:)
        @result =
          case source
          when Sourceable::MOEX then @from_moex_service.call(date: date).result
          when Sourceable::TINKOFF then @from_tinkoff_service.call.result
          end
      end
    end
  end
end
