# frozen_string_literal: true

module Portfolios
  module Cashes
    class ChangeService
      prepend BasicService

      def initialize(
        balance_change_service: Changing::BalanceService,
        income_change_service:  Changing::IncomeService
      )
        @balance_change_service = balance_change_service
        @income_change_service  = income_change_service
      end

      def call(portfolio:, scope:, cashes_params:)
        select_service(scope).call(portfolio: portfolio, cashes_params: cashes_params)
      end

      private

      def select_service(scope)
        case scope.to_i
        when 1 then @income_change_service
        when 0 then @balance_change_service
        end
      end
    end
  end
end
