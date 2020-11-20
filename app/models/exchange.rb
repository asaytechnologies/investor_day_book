# frozen_string_literal: true

class Exchange < ApplicationRecord
  include Codeable

  has_many :quotes, inverse_of: :exchange, dependent: :destroy
end
