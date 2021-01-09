# frozen_string_literal: true

module Quotes
  module Collection
    module Saving
      class MoexService
        prepend BasicService

        def initialize(coupons_create_service: ::Bonds::Coupons::CreateService.new)
          @coupons_create_service = coupons_create_service
        end

        def call(data:)
          @securities = data[:securities]

          data[:quotes].each { |element| process_quote(element) }
        end

        private

        def process_quote(data)
          data
            .merge(ticker_info: @securities[data[:ticker]])
            .then { |element| find_or_create_security(element) }
            .then { |element| find_quote(element) }
            .then { |element| find_or_create_bonds_coupons(element) }
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

          data.merge(security_id: security.id)
        end

        def find_quote(data)
          return data if data[:price].nil?

          data.merge(quote: find_or_create_quote(data))
        end

        def find_or_create_quote(data)
          attrs = { security_id: data[:security_id], price_currency: currency(data) }
          quote = Quote.find_or_initialize_by(attrs) do |object|
            object.source = Sourceable::MOEX
            object.face_value_cents = data[:ticker_info][:face_value].to_f * 100
            object.board = data[:board]
          end
          quote.price_cents = quote_price_cents(quote, data)
          quote.save!
          quote
        end

        def quote_price_cents(quote, data)
          return data[:price] * quote.face_value_cents / 100.0 if data[:security_type] == 'Bond'

          data[:price] * 100
        end

        def currency(data)
          return data[:currency] if data[:security_type] == 'Bond'

          data[:ticker_info][:boards].find { |element| element[1] == data[:board] }[2]
        end

        def find_or_create_bonds_coupons(data)
          return unless data[:quote]
          return if data[:security_type] != 'Bond'

          @coupons_create_service.call(quote: data[:quote], ticker_info: data[:ticker_info])
        end
      end
    end
  end
end
