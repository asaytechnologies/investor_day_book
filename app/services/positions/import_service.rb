# frozen_string_literal: true

module Positions
  class ImportService
    prepend BasicService

    def initialize(
      from_tinkoff_service:  Importing::TinkoffService,
      from_sberbank_service: Importing::SberbankService
    )
      @from_tinkoff_service  = from_tinkoff_service
      @from_sberbank_service = from_sberbank_service
    end

    def call(file:, portfolio:)
      case portfolio.source
      when Brokerable::TINKOFF then @from_tinkoff_service.call(file: file, portfolio: portfolio)
      when Brokerable::SBERBANK then @from_sberbank_service.call(file: file, portfolio: portfolio)
      end
    end
  end
end
