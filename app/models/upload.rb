# frozen_string_literal: true

class Upload < ApplicationRecord
  has_one_attached :file

  belongs_to :user
  belongs_to :uploadable, polymorphic: true

  scope :not_completed, -> { where completed: false }
  scope :not_failed, -> { where failed: false }
end
