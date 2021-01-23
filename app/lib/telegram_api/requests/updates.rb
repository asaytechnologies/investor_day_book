# frozen_string_literal: true

module TelegramApi
  module Requests
    module Updates
      def updates
        response = Faraday.get("#{@base_url}/getUpdates")
        response.body
      end
    end
  end
end
