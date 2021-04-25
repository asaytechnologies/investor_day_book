# frozen_string_literal: true

module Portfolios
  class Cash < ApplicationRecord
    self.table_name = :portfolios_cashes

    belongs_to :cashable, polymorphic: true

    has_many :operations,
             class_name:  'Portfolios::Cashes::Operation',
             inverse_of:  :cash,
             foreign_key: :portfolios_cash_id,
             dependent:   :destroy

    has_many :insights, as: :insightable, dependent: :destroy

    scope :balance, -> { where balance: true }
    scope :income, -> { where balance: false }

    monetize :amount_cents
  end
end
