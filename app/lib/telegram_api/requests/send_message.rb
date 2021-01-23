# frozen_string_literal: true

module TelegramApi
  module Requests
    module SendMessage
      def send_message(chat_id:, text:)
        response = Faraday.post("#{@base_url}/sendMessage") do |request|
          request.params['chat_id'] = chat_id
          request.params['text'] = text
        end
        response.body
      end
    end
  end
end
