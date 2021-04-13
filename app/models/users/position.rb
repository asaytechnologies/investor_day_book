# frozen_string_literal: true

module Users
  class Position < ApplicationRecord
    self.table_name = :users_positions

    belongs_to :portfolio
    belongs_to :quote

    scope :buying, -> { where selling_position: false }
    scope :selling, -> { where selling_position: true }
    scope :with_unsold_securities, -> { where sold_all: false }
    scope :real, -> { where plan: false }
    scope :plan, -> { where plan: true }

    validates :amount, :price, :operation_date, presence: true
    validates :amount, numericality: { only_integer: true, greater_than: 0 }
  end
end
