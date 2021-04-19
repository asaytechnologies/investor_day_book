# frozen_string_literal: true

class ActiveType < ApplicationRecord
  has_many :insights, as: :insightable, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
