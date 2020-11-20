# frozen_string_literal: true

module Quotes
  module Collection
    module Fetching
      class MoexService
        prepend BasicService

        HISTORY_COLUMNS_FOR_SELECTING = 'BOARDID,SHORTNAME,SECID,CLOSE'
        TICKER_COLUMNS_FOR_SELECTING = 'secid,boardid,currencyid'
        NO_META = 'off'

        SHARES = [
          'TQBR' # T+ Акции и ДР
        ].freeze

        FOUNDATIONS = [
          'TQTF', # T+ ETF
          'TQTE', # T+ ETF Euro
          'TQTD', # T+ ETF USD
          'TQIF' # T+ ПИФ
        ].freeze

        SKIPS = [
          'TQPI', # T+ Акции ПИР (повышенного инвестиционного риска)
          'SMAL' # T+ Неполные лоты (акции)
        ].freeze

        def initialize(moex_api_client: MoexApi::Client.new)
          @moex_api_client = moex_api_client
        end

        def call(date:)
          initialize_variables(date)
          fetch_quotes_data
          fetch_securities_data
        end

        private

        def initialize_variables(date)
          @offset  = 0
          @result  = { quotes: [], securities: {} }
          @tickers = []
          @date    = date
        end

        def fetch_quotes_data
          %w[shares].each do |market|
            loop do
              data = fetch_history_request(market)
              break if data.empty?

              data.each { |element| parse_line(element) }
              @offset += 100
            end
          end
        end

        def parse_line(line)
          security_type = security_type_by_board_id(line[0])
          return unless security_type

          @result[:quotes] << {
            security_type: security_type,
            board:         line[0],
            name:          line[1],
            ticker:        line[2],
            price:         line[3]
          }
          @tickers << line[2]
        end

        def security_type_by_board_id(board_id)
          case board_id
          when *SHARES then 'Share'
          when *FOUNDATIONS then 'Foundation'
          end
        end

        def fetch_securities_data
          @tickers.uniq.each do |ticker|
            data = fetch_security_request(ticker)
            description_data = data.dig('description', 'data')

            @result[:securities][ticker] = {
              latname: description_data.find { |element| element[0] == 'LATNAME' }[2],
              isin:    description_data.find { |element| element[0] == 'ISIN' }[2],
              boards:  data.dig('boards', 'data')
            }
          end
        end

        def fetch_history_request(market)
          @moex_api_client.stock_history(
            market:  market,
            date:    @date,
            meta:    NO_META,
            offset:  @offset,
            columns: HISTORY_COLUMNS_FOR_SELECTING
          ).dig('history', 'data')
        end

        def fetch_security_request(ticker)
          @moex_api_client.security(
            ticker:         ticker,
            meta:           NO_META,
            boards_columns: TICKER_COLUMNS_FOR_SELECTING
          )
        end
      end
    end
  end
end
