# frozen_string_literal: true

module Portfolios
  module Cashes
    module Operations
      class CreateService
        prepend BasicService

        def call(portfolios_cash:, params: {})
          portfolios_cash.operations.create!(params)
        end
      end
    end
  end
end
