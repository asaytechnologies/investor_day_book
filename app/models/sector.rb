# frozen_string_literal: true

class Sector < ApplicationRecord
  has_many :industries, dependent: :nullify
  has_many :securities, dependent: :nullify
  has_many :quotes, through: :securities

  has_many :insights, as: :insightable, dependent: :destroy
end
