# frozen_string_literal: true

module MoexApi
  module Requests
    module History
      def stock_history(market:, date:, meta: 'on', offset: nil, columns: nil)
        response = connection.get("iss/history/engines/stock/markets/#{market}/securities.json") do |request|
          request.params['date'] = date
          request.params['iss.meta'] = meta
          request.params['start'] = offset if offset
          request.params['history.columns'] = columns if columns
        end
        response.body.dig('history', 'data')
      end
    end
  end
end
