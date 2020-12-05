# frozen_string_literal: true

module Quotes
  module Collection
    module Fetching
      class TinkoffService
        prepend BasicService

        TINKOFF_API_TOKEN = Rails.application.credentials.dig(:tinkoff, :token)
        TINKOFF_API_REQUESTS_LIMIT = 100
        TINKOFF_API_REQUESTS_TIMEOUT = 45

        def initialize(tinkoff_api_client: TinkoffInvest::V1::Client.new(token: TINKOFF_API_TOKEN))
          @tinkoff_api_client = tinkoff_api_client
        end

        def call
          initialize_variables
          fetch_securities_data
        end

        private

        def initialize_variables
          @result = []
        end

        def fetch_securities_data
          fetch_stocks_data
        end

        def fetch_stocks_data
          @tinkoff_api_client
            .stocks
            .dig('payload', 'instruments')
            .each_slice(TINKOFF_API_REQUESTS_LIMIT) { |group|
              group.each { |element|
                parse_stock_line(element)
              }
              sleep(TINKOFF_API_REQUESTS_TIMEOUT) # sleep for api restrictions 120 requests per minute
            }
        end

        def parse_stock_line(line)
          quote_data = @tinkoff_api_client.orderbook(figi: line['figi'], depth: 0)
          return unless quote_data

          @result << {
            security_data: {
              type:   'Share',
              ticker: line['ticker'],
              isin:   line['isin'],
              name:   { en: line['name'], ru: line['name'] }
            },
            quote_data:    {
              price_cents:    quote_data.dig('payload', 'closePrice').to_f * 100,
              price_currency: line['currency'],
              figi:           line['figi']
            }
          }
        end
      end
    end
  end
end
