# frozen_string_literal: true

module Positions
  module Importing
    class TinkoffService < BaseService
      START_MARKER = '1.1 Информация о совершенных и исполненных сделках на конец отчетного периода'
      HEADER_MARKER = 'Номер сделки'
      END_MARKER = '1.2 Информация о неисполненных сделках на конец отчетного периода'
      REPO_MARKER = 'РЕПО'
      SELL_OPERATION_MARKER = 'Продажа'
      SELL_OPERATION = '1'
      BUY_OPERATION = '0'

      HEADER = {
        'Номер сделки'    => :external_id,
        'Дата заключения' => :operation_date,
        'Вид сделки'      => :operation,
        'Код актива'      => :ticker,
        'Цена за единицу' => :price,
        'Валюта цены'     => :price_currency,
        'Количество'      => :amount
      }.freeze

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
      # rubocop: disable Metrics/PerceivedComplexity
      def parse_rows(rows)
        list_is_started = false
        rows.each do |row|
          row = row.values if row.is_a?(Hash)
          unless list_is_started
            list_is_started = true if row[0] == START_MARKER
            next
          end
          next parse_header(row) if row[0] == HEADER_MARKER
          break if row[0] == END_MARKER
          next if row[0].to_i.zero?
          next if row[header_index(:operation)]&.include?(REPO_MARKER)

          add_position(row)
        end
      end
      # rubocop: enable Metrics/CyclomaticComplexity
      # rubocop: enable Metrics/AbcSize
      # rubocop: enable Metrics/PerceivedComplexity

      def parse_header(row)
        row.each.with_index do |element, index|
          next unless element

          header_key = HEADER[element.tr("\n", '')]
          next unless header_key

          @header_indeces[header_key] = index
        end
      end

      def add_position(row)
        @positions << {
          external_id:    row[header_index(:external_id)],
          operation_date: row[header_index(:operation_date)],
          operation:      operation(row),
          ticker:         row[header_index(:ticker)],
          price:          price(row),
          price_currency: row[header_index(:price_currency)],
          amount:         amount(row)
        }
      end

      def header_index(header_key)
        @header_indeces[header_key]
      end

      def operation(row)
        row[header_index(:operation)] == SELL_OPERATION_MARKER ? SELL_OPERATION : BUY_OPERATION
      end

      def price(row)
        row[header_index(:price)]&.tr(',', '.').to_f
      end

      def amount(row)
        row[header_index(:amount)].to_i
      end
    end
  end
end
