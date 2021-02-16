# frozen_string_literal: true

module Positions
  module Importing
    class FreedomService < BaseService
      START_MARKER = 'Тикер'
      SELL_OPERATION_MARKER = 'Продажа'
      SELL_OPERATION = '1'
      BUY_OPERATION = '0'

      def call(file:, portfolio:)
        return unless file

        @file = file
        @portfolio = portfolio

        set_initial_values
        parse_xls_file(data_sheet_index: 2)
        save_positions
      end

      private

      def parse_rows(rows)
        rows.each do |row|
          row = row.values if row.is_a?(Hash)
          next if row[0] == START_MARKER

          add_position(row)
        end
      end

      def add_position(row)
        security = find_security(row)
        return unless security

        @positions << {
          external_id:    row[13],
          operation_date: row[11],
          operation:      operation(row),
          ticker:         security.ticker,
          price:          row[5].is_a?(String) ? row[5].tr(',', '.').to_f : row[5].to_f,
          price_currency: row[6],
          amount:         row[4].to_i
        }
      end

      def find_security(row)
        Security.find_by(isin: row[1])
      end

      def operation(row)
        row[3] == SELL_OPERATION_MARKER ? SELL_OPERATION : BUY_OPERATION
      end
    end
  end
end
