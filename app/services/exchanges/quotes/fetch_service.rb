# frozen_string_literal: true

module Exchanges
  module Quotes
    class FetchService
      prepend BasicService

      def initialize(
        fetch_from_moex_service: Fetching::MoexService
      )
        @fetch_from_moex_service = fetch_from_moex_service
      end

      def call(source:)
        case source
        when Sourceable::MOEX then @fetch_from_moex_service.call
        end
      end
    end
  end
end
