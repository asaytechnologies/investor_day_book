# frozen_string_literal: true

require 'dry/initializer'

module MoexApi
  class Client
    extend Dry::Initializer
    include Requests::History
    include Requests::Security

    BASE_URL = 'https://iss.moex.com/'

    option :url, default: proc { BASE_URL }
    option :connection, default: proc { build_connection }

    private

    def build_connection
      Faraday.new(@url) do |conn|
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
