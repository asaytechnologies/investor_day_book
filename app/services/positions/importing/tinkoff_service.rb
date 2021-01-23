# frozen_string_literal: true

module Positions
  module Importing
    class TinkoffService
      prepend BasicService

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
        destroy_old_positions
        save_positions
      end

      private

      def parse_xls_file
        @file.open do |file|
          rows = read_xls_file_rows(file)
          break unless rows

          parse_rows(rows)
        end
      end

      def read_xls_file_rows(file)
        case File.extname(file)
        when '.xlsx' then Creek::Book.new(file).sheets[0].rows
        when '.xls' then Roo::Excel.new(file).sheet(0)
        end
      end

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

      def destroy_old_positions
        @portfolio.positions.destroy_all
      end

      def save_positions
        @positions.each do |position|
          quote =
            Quote
            .joins(:security)
            .where(price_currency: position[:price_currency])
            .where(securities: { ticker: position[:ticker] })
            .first
          next unless quote

          attrs = { portfolio: @portfolio, quote: quote }
          attrs = attrs.merge(position.slice(:price, :price_currency, :amount, :operation, :operation_date))
          Positions::CreateService.call(attrs)
        end
      end
    end
  end
end
