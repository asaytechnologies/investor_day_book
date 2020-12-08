# frozen_string_literal: true

module Quotes
  class SearchService
    prepend BasicService

    def initialize(
      list_search_service:      Searching::ListService,
      full_text_search_service: Searching::FullTextService
    )
      @list_search_service      = list_search_service
      @full_text_search_service = full_text_search_service
    end

    def call(query: '')
      @result =
        case query.size
        when 0 then nil
        when 1, 2 then @list_search_service.call(query: query).result
        else @full_text_search_service.call(query: query).result
        end
    end
  end
end
