# frozen_string_literal: true

module Quotes
  module Searching
    class FullTextService
      prepend BasicService

      def call(query: '')
        @result = Quote.search("*#{query}*")
      end
    end
  end
end
