# frozen_string_literal: true

module Positions
  module Importing
    class VtbService < BaseService
      START_MARKER = 'Заключенные в отчетном периоде сделки с ценными бумагами'
      STOP_MARKER = 'Завершенные в отчетном периоде сделки с ценными бумагами'
      HEADER_MARKER = 'Наименование ценной бумаги'
      SELL_OPERATION_MARKER = 'Продажа'
      SELL_OPERATION = '1'
      BUY_OPERATION = '0'

      def call(file:, portfolio:)
        return unless file

        @file = file
        @portfolio = portfolio

        set_initial_values
        parse_xls_file
        save_positions
      end

      private

      # rubocop: disable Metrics/CyclomaticComplexity
      # rubocop: disable Metrics/AbcSize
      def parse_rows(rows)
        list_is_started = false
        rows.each do |row|
          row = row.values if row.is_a?(Hash)
          next if row[0].blank?

          unless list_is_started
            list_is_started = true if row[0].to_s.include?(START_MARKER)
            next
          end
          next if row[0].to_s.include?(HEADER_MARKER)
          break if row[0].to_s.include?(STOP_MARKER)

          add_position(row)
        end
      end
      # rubocop: enable Metrics/CyclomaticComplexity
      # rubocop: enable Metrics/AbcSize

      def add_position(row)
        security = find_security(row)
        return unless security

        currency = find_currency(row)
        price    = find_price(row)
        if security.is_a?(Bond)
          price *= security.quotes.find_by(price_currency: currency).face_value_cents / 100.0
        end

        @positions << {
          external_id:    row[50],
          operation_date: row[2],
          operation:      row[4] == SELL_OPERATION_MARKER ? SELL_OPERATION : BUY_OPERATION,
          ticker:         security.ticker,
          price:          price,
          price_currency: currency,
          amount:         row[8].to_i
        }
      end

      def find_security(row)
        Security.find_by(isin: row[0].split(', ').last)
      end

      def find_currency(row)
        row[10] == 'RUR' ? Cashable::RUB_UPCASE : row[10]
      end

      def find_price(row)
        row[14].to_f
      end
    end
  end
end
