# frozen_string_literal: true

module Quotes
  module Collection
    module Saving
      class MoexService
        prepend BasicService

        COLUMNS_FOR_SELECTING = 'secid,boardid,currencyid'
        NO_META = 'off'

        def initialize; end

        def call(quotes:)
          @securities = quotes[:securities]

          quotes[:quotes].each { |element| process_quote(element) }
        end

        private

        def process_quote(data)
          data
            .merge(ticker_info: @securities[data[:ticker]])
            .then { |element| find_or_create_security(element) }
            .then { |element| find_or_create_quote(element) }
        end

        def find_or_create_security(data)
          security =
            Security.find_or_create_by(
              ticker: data[:ticker],
              type:   data[:security_type],
              isin:   data[:ticker_info][:isin]
            ) do |object|
              object.name = { ru: data[:name], en: data[:ticker_info][:latname] }
            end

          data.merge(security: security)
        end

        def find_or_create_quote(data)
          return if data[:price].nil?

          quote = find_quote(data)
          update_price_for_quote(quote, data)
        end

        def find_quote(data)
          Quote.find_or_initialize_by(security: data[:security], board: data[:board]) do |object|
            object.source = Sourceable::MOEX
          end
        end

        def update_price_for_quote(quote, data)
          if quote.new_record?
            currency = data[:ticker_info][:boards].find { |element| element[1] == data[:board] }[2]
            quote.price = Money.new(data[:price] * 100, currency)
          else
            quote.price_cents = data[:price] * 100
          end
          quote.save
        end
      end
    end
  end
end
