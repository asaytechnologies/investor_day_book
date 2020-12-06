# frozen_string_literal: true

require 'dry/initializer'

module IexCloudApi
  class Client
    extend Dry::Initializer
    include Stocks::Company

    BASE_URL = 'https://cloud.iexapis.com/stable/'
    TOKEN = Rails.application.credentials.dig(:iex_cloud, :token)

    option :url, default: proc { BASE_URL }
    option :token, default: proc { TOKEN }
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
