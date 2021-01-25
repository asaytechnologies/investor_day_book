# frozen_string_literal: true

module Quotes
  module Synchronization
    class TinkoffJob < SynchronizeJob
      SKIPPED_DAY_INDECES = [0].freeze

      def perform
        return if skipped_day?(SKIPPED_DAY_INDECES)

        Quotes::Collection::SynchronizeService.call(source: 'tinkoff')
        Infosnag.call(text: "Синхронизация котировок с Tinkoff завершена, #{Time.zone.today}")
      end
    end
  end
end
