# frozen_string_literal: true

module Exchanges
  module Quotes
    module Daily
      module Saving
        class MoexService
          prepend BasicService

          COLUMNS_FOR_SELECTING = 'secid,boardid,currencyid'
          NO_META = 'off'

          def initialize(moex_api_client: MoexApi::Client.new)
            @moex_api_client = moex_api_client
          end

          def call(exchanges_quotes:)
            @exchange = Exchange.find_by(source: Sourceable::MOEX)

            exchanges_quotes.each(&method(:process_exchange_quote))
          end

          private

          def process_exchange_quote(data)
            data
              .then(&method(:find_or_create_security))
              .then(&method(:find_or_create_exchange_quote))
          end

          def find_or_create_security(data)
            security = data[:security_type].constantize.find_or_create_by(ticker: data[:ticker]) do |object|
              object.name = { ru: data[:name], en: '' }
            end
            data.except(:security_type).merge(security: security)
          end

          def find_or_create_exchange_quote(data)
            return if data[:price].nil?

            Exchanges::Quote.find_or_create_by(exchange: @exchange, securitiable: data[:security]) do |object|
              currency = fetch_additional_security_data(data)
              object.price = Money.new(data[:price] * 100, currency)
            end
          end

          def fetch_additional_security_data(data)
            response_data = fetch_security_request(data[:ticker])
            update_security_english_name(data[:security], response_data.dig('description', 'data'))

            response_data.dig('boards', 'data').find { |element| element[1] == data[:board] }[2]
          end

          def fetch_security_request(ticker)
            @moex_api_client.security(
              ticker:         ticker,
              meta:           NO_META,
              boards_columns: COLUMNS_FOR_SELECTING
            )
          end

          def update_security_english_name(security, description_data)
            security.name[:en] = description_data.find { |element| element[0] == 'LATNAME' }[2]
            security.save
          end
        end
      end
    end
  end
end
