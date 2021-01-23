# frozen_string_literal: true

module Quotes
  module Collection
    module Fetching
      class TinkoffService
        prepend BasicService

        TINKOFF_API_TOKEN = Rails.application.credentials.dig(:tinkoff, :token)
        TINKOFF_API_REQUESTS_LIMIT = 100
        TINKOFF_API_REQUESTS_TIMEOUT = 70

        def initialize(tinkoff_api_client: TinkoffInvest::V1::Client.new(token: TINKOFF_API_TOKEN))
          @tinkoff_api_client = tinkoff_api_client
        end

        def call
          initialize_variables
          fetch_data(:stocks, 'Share')
          fetch_data(:bonds, 'Bond')
          fetch_data(:etfs, 'Foundation')
        end

        private

        def initialize_variables
          @result = []
        end

        def fetch_data(method, type)
          @tinkoff_api_client
            .send(method)
            .dig('payload', 'instruments')
            .each_slice(TINKOFF_API_REQUESTS_LIMIT) { |group|
              group.each { |element| parse_line(element, type) }
              sleep(TINKOFF_API_REQUESTS_TIMEOUT) # sleep for api restrictions 120 requests per minute
            }
        end

        def parse_line(line, type)
          quote_data = @tinkoff_api_client.orderbook(figi: line['figi'], depth: 0)
          return unless quote_data

          @result << {
            security_data: {
              type:   type,
              ticker: line['ticker'],
              isin:   line['isin'],
              name:   { en: line['name'], ru: line['name'] }
            },
            quote_data:    {
              face_value_cents: line['faceValue'].to_f * 100,
              price:            quote_data.dig('payload', 'lastPrice').to_f,
              price_currency:   line['currency'],
              figi:             line['figi']
            }
          }
        end
      end
    end
  end
end
