# frozen_string_literal: true

module Exchanges
  module Quotes
    module Daily
      class SaveService
        prepend BasicService

        def initialize; end

        def call(exchanges_quotes:, source:); end
      end
    end
  end
end
