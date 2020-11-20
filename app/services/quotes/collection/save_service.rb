# frozen_string_literal: true

module Quotes
  module Collection
    class SaveService
      prepend BasicService

      def initialize(
        save_from_moex_service: Saving::MoexService
      )
        @save_from_moex_service = save_from_moex_service
      end

      def call(quotes:, source:)
        return unless quotes

        case source
        when Sourceable::MOEX then @save_from_moex_service.call(quotes: quotes)
        end
      end
    end
  end
end
