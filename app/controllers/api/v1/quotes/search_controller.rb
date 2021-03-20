# frozen_string_literal: true

module Api
  module V1
    module Quotes
      class SearchController < Api::V1::BaseController
        before_action :find_quotes, only: %i[index]

        def index
          render json: { quotes: ::QuoteSerializer.new(@quotes).serializable_hash }, status: :ok
        end

        private

        def find_quotes
          quote_ids =
            params[:query].blank? ? [] : ::Quotes::SearchService.call(query: params[:query]).result&.map(&:id)
          @quotes = Quote.where(id: quote_ids).includes(:security)
        end
      end
    end
  end
end
