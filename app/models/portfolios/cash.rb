# frozen_string_literal: true

module Portfolios
  class Cash < ApplicationRecord
    self.table_name = :portfolios_cashes

    belongs_to :portfolio

    monetize :amount_cents
  end
end
