# frozen_string_literal: true

module Quotes
  module Collection
    class SyncronizeJob < ApplicationJob
      queue_as :default

      SKIPPED_DAY_INDECES = [0, 1].freeze

      def perform
        # skip on sunday and monday
        return if Time.zone.today.wday.in?(SKIPPED_DAY_INDECES)

        Quotes::Collection::SyncronizeService.call(source: 'moex', date: (Time.zone.today - 1.day).to_s)
        Quotes::Collection::SyncronizeService.call(source: 'tinkoff')
        ExchangeRates::SyncronizeService.call
        Infosnag.call(text: "Синхронизация котировок завершена, #{Time.zone.today}")
      end
    end
  end
end
