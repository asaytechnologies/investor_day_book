# frozen_string_literal: true

module Users
  class Position < ApplicationRecord
    self.table_name = :users_positions

    belongs_to :portfolio
    belongs_to :quote

    monetize :price_cents
  end
end
