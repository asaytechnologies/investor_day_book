# frozen_string_literal: true

module IexCloudApi
  module ReferenceData
    module Sectors
      def sectors
        response = connection.get('ref-data/sectors') do |request|
          request.params['token'] = @token
        end
        response.body
      end
    end
  end
end
