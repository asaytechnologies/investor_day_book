# frozen_string_literal: true

class Upload < ApplicationRecord
  has_one_attached :file

  belongs_to :user

  scope :not_completed, -> { where completed: false }
end
