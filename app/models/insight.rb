# frozen_string_literal: true

class Insight < ApplicationRecord
  belongs_to :portfolio
  belongs_to :quote
  belongs_to :insightable, polymorphic: true, optional: true

  scope :real, -> { where plan: false }
  scope :plan, -> { where plan: true }

  validates :amount, :price, presence: true
  validates :amount, numericality: { only_integer: true, greater_than: 0 }
end
