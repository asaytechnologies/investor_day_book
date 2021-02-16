# frozen_string_literal: true

module Positions
  class ImportService
    prepend BasicService

    def initialize(
      from_tinkoff_service:  Importing::TinkoffService,
      from_sberbank_service: Importing::SberbankService,
      from_vtb_service:      Importing::VtbService,
      from_freedom_service:  Importing::FreedomService
    )
      @from_tinkoff_service  = from_tinkoff_service
      @from_sberbank_service = from_sberbank_service
      @from_vtb_service      = from_vtb_service
      @from_freedom_service  = from_freedom_service
    end

    def call(file:, portfolio:)
      case portfolio.source
      when Brokerable::TINKOFF then @from_tinkoff_service.call(file: file, portfolio: portfolio)
      when Brokerable::SBERBANK then @from_sberbank_service.call(file: file, portfolio: portfolio)
      when Brokerable::VTB then @from_vtb_service.call(file: file, portfolio: portfolio)
      when Brokerable::FREEDOM then @from_freedom_service.call(file: file, portfolio: portfolio)
      end
    end
  end
end
