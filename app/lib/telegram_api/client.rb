# frozen_string_literal: true

require 'dry/initializer'

module TelegramApi
  class Client
    extend Dry::Initializer
    include Requests::Updates
    include Requests::SendMessage

    API_URL = 'https://api.telegram.org'
    TOKEN = Rails.application.credentials.dig(:telegram, :token)

    option :api_url, default: proc { API_URL }
    option :token, default: proc { TOKEN }
    option :base_url, default: proc { build_base_url }

    private

    def build_base_url
      "#{@api_url}/bot#{@token}"
    end
  end
end
