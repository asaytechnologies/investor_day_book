# frozen_string_literal: true

module Portfolios
  module Cashes
    module Changing
      class BalanceService
        prepend BasicService

        def initialize(
          cash_update_service: UpdateService
        )
          @cash_update_service = cash_update_service
        end

        def call(portfolio:, cashes_params:)
          @portfolios_cashes = portfolio.cashes.balance
          @cashes_params     = cashes_params

          ActiveRecord::Base.transaction do
            perform_cashes_changes
            perform_insights_changes(portfolio)
          end
        end

        private

        def perform_cashes_changes
          @portfolios_cashes.each { |portfolios_cash| perform_cash_change(portfolios_cash) }
        end

        def perform_cash_change(portfolios_cash)
          amount_cents = @cashes_params[portfolios_cash.amount_currency.downcase].to_f * 100

          @cash_update_service.call(
            portfolios_cash: portfolios_cash,
            params:          { amount_cents: amount_cents }
          )
        end

        def perform_insights_changes(portfolio)
          Insights::ForCash::RefreshService.call(parentable: portfolio)
        end
      end
    end
  end
end
