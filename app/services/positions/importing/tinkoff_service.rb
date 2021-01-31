# frozen_string_literal: true

module Positions
  module Importing
    class TinkoffService < BaseService
      START_MARKER = '1.1 Информация о совершенных и исполненных сделках на конец отчетного периода'
      END_MARKER = '1.2 Информация о неисполненных сделках на конец отчетного периода'
      REPO_MARKER = 'РЕПО'
      SELL_OPERATION_MARKER = 'Продажа'
      SELL_OPERATION = '1'
      BUY_OPERATION = '0'

      def call(file:, portfolio:)
        return unless file

        @file = file
        @portfolio = portfolio
        @positions = []

        parse_xls_file
        save_positions
      end

      private

      # rubocop: disable Metrics/CyclomaticComplexity
      def parse_rows(rows)
        list_is_started = false
        rows.each do |row|
          row = row.values if row.is_a?(Hash)
          unless list_is_started
            list_is_started = true if row[0] == START_MARKER
            next
          end
          break if row[0] == END_MARKER
          next if row[0].to_i.zero?
          next if row[22].include?(REPO_MARKER)

          add_position(row)
        end
      end
      # rubocop: enable Metrics/CyclomaticComplexity

      def add_position(row)
        @positions << {
          external_id:    row[0],
          operation_date: row[5],
          operation:      row[22] == SELL_OPERATION_MARKER ? SELL_OPERATION : BUY_OPERATION,
          ticker:         row[33],
          price:          row[38].tr(',', '.').to_f,
          price_currency: row[43],
          amount:         row[47].to_i
        }
      end
    end
  end
end
