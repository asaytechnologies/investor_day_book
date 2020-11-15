# frozen_string_literal: true

class Sector < ApplicationRecord
  has_many :industries, dependent: :nullify
  has_many :bonds, through: :industries
  has_many :shares, through: :industries
end
