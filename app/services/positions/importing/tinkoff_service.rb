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
        list_is_started = false
        @file.open do |file|
          Roo::Excel.new(file).sheet(0).each do |row|
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
      end

      def add_position(row)
        @positions << {
          external_id:    row[0],
          operation_date: DateTime.parse(row[5]),
          operation:      row[22] == SELL_OPERATION_MARKER ? SELL_OPERATION : BUY_OPERATION,
          ticker:         row[33],
          price:          row[38].tr(',', '.').to_f,
          currency:       row[43],
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
            .where(price_currency: position[:currency])
            .where(securities: { ticker: position[:ticker] })
            .first
          next unless quote

          Positions::CreateService.call(
            portfolio:      @portfolio,
            quote:          quote,
            price:          Money.new(position[:price] * 100, position[:currency]),
            amount:         position[:amount],
            operation:      position[:operation],
            operation_date: position[:operation_date]
          )
        end
      end
    end
  end
end
