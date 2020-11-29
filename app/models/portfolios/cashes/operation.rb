# frozen_string_literal: true

module Portfolios
  module Cashes
    class Operation < ApplicationRecord
      self.table_name = :portfolios_cashes_operations

      belongs_to :cash, class_name: 'Portfolios::Cash', foreign_key: :portfolios_cash_id, inverse_of: :operations
    end
  end
end
