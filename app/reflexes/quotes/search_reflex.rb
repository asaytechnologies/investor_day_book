# frozen_string_literal: true

module Quotes
  class SearchReflex < ApplicationReflex
    def perform
      return unless element[:value].size > 2

      quotes_ids = Quote.search("*#{element[:value]}*").map(&:id)
      @quotes = Quote.where(id: quotes_ids).includes(:security).order('securities.type DESC')
    end
  end
end
