# frozen_string_literal: true

module Portfolios
  module Cashes
    class UpdateService
      prepend BasicService

      def call(portfolios_cash:, params: {})
        portfolios_cash.update!(params)
      end
    end
  end
end
