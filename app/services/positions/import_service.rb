# frozen_string_literal: true

module Positions
  class ImportService
    prepend BasicService

    def initialize(
      from_tinkoff_service: Importing::TinkoffService
    )
      @from_tinkoff_service = from_tinkoff_service
    end

    def call(source:, file:, portfolio:)
      case source
      when Sourceable::TINKOFF then @from_tinkoff_service.call(file: file, portfolio: portfolio)
      end
    end
  end
end
