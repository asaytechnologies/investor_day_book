# frozen_string_literal: true

module Positions
  module Importing
    class SberbankService < BaseService
      START_MARKER = 'Номер договора'
      SELL_OPERATION_MARKER = 'Продажа'
      SELL_OPERATION = '1'
      BUY_OPERATION = '0'

      def call(file:, portfolio:)
        return unless file

        @file = file
        @portfolio = portfolio

        set_initial_values
        parse_xls_file(data_sheet_index: 0)
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
        @positions << {
          external_id:    row[1],
          operation_date: row[2],
          operation:      row[7] == SELL_OPERATION_MARKER ? SELL_OPERATION : BUY_OPERATION,
          ticker:         row[4],
          price:          row[9].is_a?(String) ? row[9].tr(',', '.').to_f : row[9].to_f,
          price_currency: row[12],
          amount:         row[8].to_i
        }
      end
    end
  end
end
