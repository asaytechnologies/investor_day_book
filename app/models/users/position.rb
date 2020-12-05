# frozen_string_literal: true

module Users
  class Position < ApplicationRecord
    self.table_name = :users_positions

    belongs_to :portfolio
    belongs_to :quote

    monetize :price_cents

    scope :buying, -> { where selling_position: false }
    scope :selling, -> { where selling_position: true }
    scope :with_unsold_securities, -> { where sold_all: false }
  end
end
