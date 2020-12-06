# frozen_string_literal: true

module IexCloudApi
  module Stocks
    module Company
      def company(ticker:)
        response = connection.get("stock/#{ticker}/company") do |request|
          request.params['token'] = @token
        end
        response.body
      end
    end
  end
end
