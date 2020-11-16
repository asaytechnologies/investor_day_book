# frozen_string_literal: true

module Exchanges
  module Quotes
    module Daily
      module Fetching
        class MoexService
          prepend BasicService

          COLUMNS_FOR_SELECTING = 'BOARDID,SHORTNAME,SECID,CLOSE'
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

          attr_reader :result

          def initialize(moex_api_client: MoexApi::Client.new)
            @moex_api_client = moex_api_client
          end

          def call(date:)
            initialize_variables(date)

            %w[shares].each do |market|
              loop do
                data = make_request(market)
                break if data.empty?

                data.each(&method(:parse_line))
                @offset += 100
              end
            end
          end

          private

          def initialize_variables(date)
            @offset = 0
            @result = []
            @date   = date
          end

          def make_request(market)
            @moex_api_client.history(
              market:  market,
              date:    @date,
              meta:    NO_META,
              offset:  @offset,
              columns: COLUMNS_FOR_SELECTING
            )
          end

          def parse_line(line)
            security = security_by_board_id(line[0])
            return unless security

            @result << {
              security: security,
              name:     line[1],
              ticker:   line[2],
              price:    line[3]
            }
          end

          def security_by_board_id(board_id)
            case board_id
            when *SHARES then :share
            when *FOUNDATIONS then :foundation
            end
          end
        end
      end
    end
  end
end
