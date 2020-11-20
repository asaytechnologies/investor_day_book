# frozen_string_literal: true

class Industry < ApplicationRecord
  belongs_to :sector, optional: true

  has_many :securities, dependent: :nullify
end
