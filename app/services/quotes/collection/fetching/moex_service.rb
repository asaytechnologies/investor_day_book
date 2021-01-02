# frozen_string_literal: true

module Quotes
  module Collection
    module Fetching
      class MoexService
        prepend BasicService

        HISTORY_COLUMNS_FOR_SELECTING = 'BOARDID,SHORTNAME,SECID,CLOSE,FACEUNIT'
        TICKER_COLUMNS_FOR_SELECTING = 'secid,boardid,currencyid'
        NO_META = 'off'
        MOEX_API_REQUESTS_LIMIT = 100
        MOEX_API_REQUESTS_TIMEOUT = 30

        SHARES = [
          'TQBR' # T+ Акции и ДР
        ].freeze

        BONDS = [
          'TQOD', # Т+ Облигации (USD)
          'TQCB', # Т+ Облигации
          'TQRD' # Т+: Облигации Д
        ].freeze

        FOUNDATIONS = [
          'TQTF', # T+ ETF
          'TQTE', # T+ ETF Euro
          'TQTD', # T+ ETF USD
          'TQIF' # T+ ПИФ
        ].freeze

        SKIPS = [
          'TQPI', # T+ Акции ПИР (повышенного инвестиционного риска)
          'SMAL', # T+ Неполные лоты (акции),
          'TQIR' # Т+ Облигации ПИР
        ].freeze

        SHARES_DESCRIPTION_DATA = {
          'LATNAME' => :latname,
          'ISIN'    => :isin
        }.freeze

        BONDS_DESCRIPTION_DATA = {
          'LATNAME'          => :latname,
          'ISIN'             => :isin,
          'COUPONVALUE'      => :coupon_value,
          'COUPONFREQUENCY'  => :coupon_frequency,
          'MATDATE'          => :end_date,
          'BUYBACKDAT'       => :buy_back_date,
          'ISSUEDATE'        => :start_date,
          'INITIALFACEVALUE' => :face_value
        }.freeze

        def initialize(moex_api_client: MoexApi::Client.new)
          @moex_api_client = moex_api_client
        end

        def call(date:)
          initialize_variables(date)
          fetch_shares_data
          fetch_bonds_data
          fetch_shares_securities_data
          fetch_bonds_securities_data
        end

        private

        def initialize_variables(date)
          @result         = { quotes: [], securities: {} }
          @shares_tickers = []
          @bonds_tickers  = []
          @date           = date
        end

        def fetch_shares_data
          offset = 0
          loop do
            data = history_request('shares', offset)
            break if data.empty?

            data.each { |element| parse_shares_line(element) }
            offset += 100
          end
          sleep(MOEX_API_REQUESTS_TIMEOUT) # sleep for api restrictions
        end

        def fetch_bonds_data
          offset = 0
          loop do
            data = history_request('bonds', offset)
            break if data.empty?

            data.each { |element| parse_bonds_line(element) }
            offset += 100
          end
          sleep(MOEX_API_REQUESTS_TIMEOUT) # sleep for api restrictions
        end

        def parse_shares_line(line)
          security_type = security_type_by_board_id(line[0])
          return unless security_type

          price = line[3]
          return unless price

          @result[:quotes] << {
            security_type: security_type,
            board:         line[0],
            name:          line[1],
            ticker:        line[2],
            price:         price
          }
          @shares_tickers << line[2]
        end

        def parse_bonds_line(line)
          security_type = security_type_by_board_id(line[0])
          return unless security_type

          price = line[3]
          return unless price

          @result[:quotes] << {
            security_type: security_type,
            board:         line[0],
            name:          line[1],
            ticker:        line[2],
            price:         price * 10.0,
            currency:      line[4]
          }
          @bonds_tickers << line[2]
        end

        def security_type_by_board_id(board_id)
          case board_id
          when *SHARES then 'Share'
          when *BONDS then 'Bond'
          when *FOUNDATIONS then 'Foundation'
          end
        end

        def fetch_shares_securities_data
          @shares_tickers.uniq.each_slice(MOEX_API_REQUESTS_LIMIT) do |group|
            group.each do |ticker|
              data = security_request(ticker)
              data
                .dig('description', 'data')
                .then { |element| parse_shares_description_data(element) }
                .then { |element| @result[:securities][ticker] = element.merge(boards: data.dig('boards', 'data')) }
            end
            sleep(MOEX_API_REQUESTS_TIMEOUT) # sleep for api restrictions
          end
        end

        def parse_shares_description_data(description_data)
          description_data.each_with_object({}) do |element, acc|
            next unless SHARES_DESCRIPTION_DATA.key?(element[0])

            acc[SHARES_DESCRIPTION_DATA[element[0]]] = element[2]
          end
        end

        def fetch_bonds_securities_data
          @bonds_tickers.uniq.each_slice(MOEX_API_REQUESTS_LIMIT) do |group|
            group.each do |ticker|
              data = security_request(ticker)
              data
                .dig('description', 'data')
                .then { |element| parse_bonds_description_data(element) }
                .then { |element| @result[:securities][ticker] = element }
            end
            sleep(MOEX_API_REQUESTS_TIMEOUT) # sleep for api restrictions
          end
        end

        def parse_bonds_description_data(description_data)
          description_data.each_with_object({}) do |element, acc|
            next unless BONDS_DESCRIPTION_DATA.key?(element[0])

            acc[BONDS_DESCRIPTION_DATA[element[0]]] = element[2]
          end
        end

        def history_request(market, offset)
          @moex_api_client.stock_history(
            market:  market,
            date:    @date,
            meta:    NO_META,
            offset:  offset,
            columns: HISTORY_COLUMNS_FOR_SELECTING
          ).dig('history', 'data')
        end

        def security_request(ticker)
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
