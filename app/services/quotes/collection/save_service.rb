# frozen_string_literal: true

module Quotes
  module Collection
    class SaveService
      prepend BasicService

      def initialize(
        save_from_moex_service:    Saving::MoexService,
        save_from_tinkoff_service: Saving::TinkoffService
      )
        @save_from_moex_service    = save_from_moex_service
        @save_from_tinkoff_service = save_from_tinkoff_service
      end

      def call(data:, source:)
        return unless data

        case source
        when Sourceable::MOEX then @save_from_moex_service.call(data: data)
        when Sourceable::TINKOFF then @save_from_tinkoff_service.call(data: data)
        end
      end
    end
  end
end
