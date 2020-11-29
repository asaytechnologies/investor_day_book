# frozen_string_literal: true

module Portfolios
  class Cash < ApplicationRecord
    self.table_name = :portfolios_cashes

    belongs_to :portfolio

    has_many :operations,
             class_name:  'Portfolios::Cashes::Operation',
             inverse_of:  :cash,
             foreign_key: :portfolios_cash_id,
             dependent:   :destroy

    monetize :amount_cents
  end
end
