# frozen_string_literal: true

class Upload < ApplicationRecord
  has_one_attached :file

  belongs_to :user
end
