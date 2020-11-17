# frozen_string_literal: true

module Exchanges
  module Quotes
    module Daily
      class SaveService
        prepend BasicService

        def initialize(
          save_from_moex_service: Saving::MoexService
        )
          @save_from_moex_service = save_from_moex_service
        end

        def call(exchanges_quotes:, source:)
          return unless exchanges_quotes

          case source
          when Sourceable::MOEX then @save_from_moex_service.call(exchanges_quotes: exchanges_quotes)
          end
        end
      end
    end
  end
end
