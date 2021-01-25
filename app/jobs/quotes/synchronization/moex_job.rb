# frozen_string_literal: true

module Quotes
  module Synchronization
    class MoexJob < SynchronizeJob
      SKIPPED_DAY_INDECES = [0, 1].freeze

      def perform
        return if skipped_day?(SKIPPED_DAY_INDECES)

        Quotes::Collection::SynchronizeService.call(source: 'moex', date: (Time.zone.today - 1.day).to_s)
        Infosnag.call(text: "Синхронизация котировок с MOEX завершена, #{Time.zone.today}")
      end
    end
  end
end
