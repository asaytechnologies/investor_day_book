# frozen_string_literal: true

module Portfolios
  class CreateService
    prepend BasicService

    def initialize(
      cash_create_service: Cashes::CreateService
    )
      @cash_create_service = cash_create_service
    end

    def call(args={})
      create_portfolio(args)
        .then { |portfolio| @cash_create_service.call(portfolio: portfolio) }
    end

    private

    def create_portfolio(args)
      Portfolio.create(args)
    end
  end
end
