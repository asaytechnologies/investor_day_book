# frozen_string_literal: true

class Industry < ApplicationRecord
  belongs_to :sector, optional: true

  has_many :bonds, dependent: :nullify
  has_many :shares, dependent: :nullify
end
