# frozen_string_literal: true

module ExchangeRatesApi
  module Request
    module Latest
      def latest(base: nil, symbols: [])
        response = connection.get('latest') do |request|
          request.params['base'] = base if base
          request.params['symbols'] = symbols.join(',') if symbols.present?
        end
        response.body
      end
    end
  end
end
