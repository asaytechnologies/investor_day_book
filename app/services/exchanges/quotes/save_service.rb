# frozen_string_literal: true

module Exchanges
  module Quotes
    class SaveService
      prepend BasicService

      def initialize; end

      def call(exchanges_quotes:, source:); end
    end
  end
end
