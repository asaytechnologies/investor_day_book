# frozen_string_literal: true

class Insight < ApplicationRecord
  # portfolio or user
  belongs_to :parentable, polymorphic: true
  # quote, sector or active_type
  # or portfolios_cash
  belongs_to :insightable, polymorphic: true

  scope :real, -> { where plan: false }
  scope :plan, -> { where plan: true }
end
