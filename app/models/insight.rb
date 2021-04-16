# frozen_string_literal: true

class Insight < ApplicationRecord
  belongs_to :parentable, polymorphic: true
  belongs_to :insightable, polymorphic: true

  scope :real, -> { where plan: false }
  scope :plan, -> { where plan: true }
end
