# frozen_string_literal: true

module Quotes
  module Synchronization
    class ExchangeRatesJob < SynchronizeJob
      SKIPPED_DAY_INDECES = [0].freeze

      def perform
        return if skipped_day?(SKIPPED_DAY_INDECES)

        ExchangeRates::SynchronizeService.call
        Infosnag.call(text: "Синхронизация курсов валют завершена, #{Time.zone.today}")
      end
    end
  end
end
