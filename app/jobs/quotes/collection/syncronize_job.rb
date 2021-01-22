# frozen_string_literal: true

module Quotes
  module Collection
    class SyncronizeJob < ApplicationJob
      queue_as :default

      SKIPPED_DAY_INDECES = [0, 7].freeze

      def perform
        # skip on sunday and monday
        return if Time.zone.today.wday.in?(SKIPPED_DAY_INDECES)

        Quotes::Collection::SyncronizeService.call(source: 'moex', date: (Time.zone.today - 1.day).to_s)
        Quotes::Collection::SyncronizeService.call(source: 'tinkoff')
        ExchangeRates::SyncronizeService.call
        success_notify
      end

      private

      def success_notify
        Bugsnag.notify('Quotes syncronization is completed') do |report|
          report.severity = 'info'
        end
      end
    end
  end
end
