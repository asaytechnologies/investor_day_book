# frozen_string_literal: true

module Portfolios
  module Cashes
    module Changing
      class IncomeService
        prepend BasicService

        def initialize(
          operation_create_service: Operations::CreateService,
          cash_update_service:      UpdateService
        )
          @operation_create_service = operation_create_service
          @cash_update_service      = cash_update_service
        end

        def call(portfolio:, cashes_params:)
          @portfolios_cashes = portfolio.cashes.income
          @cashes_params     = cashes_params

          ActiveRecord::Base.transaction do
            define_multiplicator
            perform_cashes_changes
          end
        end

        private

        def define_multiplicator
          @multiplicator = @cashes_params['operation'] == '0' ? 1 : -1
        end

        def perform_cashes_changes
          @portfolios_cashes.each { |portfolios_cash| perform_cash_change(portfolios_cash) }
        end

        def perform_cash_change(portfolios_cash)
          amount_cents = @cashes_params[portfolios_cash.amount_currency.downcase].to_f * 100 * @multiplicator
          return if amount_cents.zero?

          @operation_create_service.call(portfolios_cash: portfolios_cash, params: { amount_cents: amount_cents })
          @cash_update_service.call(
            portfolios_cash: portfolios_cash,
            params:          { amount_cents: portfolios_cash.amount_cents + amount_cents }
          )
        end
      end
    end
  end
end
