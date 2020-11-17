# frozen_string_literal: true

module MoexApi
  module Requests
    module Security
      def security(ticker:, meta: 'on', description_columns: nil, boards_columns: nil)
        response = connection.get("iss/securities/#{ticker}.json") do |request|
          request.params['iss.meta'] = meta
          request.params['description.columns'] = description_columns if description_columns
          request.params['boards.columns'] = boards_columns if boards_columns
        end
        response.body
      end
    end
  end
end
