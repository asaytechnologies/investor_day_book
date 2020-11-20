# frozen_string_literal: true

class Quote < ApplicationRecord
  belongs_to :exchange
  belongs_to :security

  monetize :price_cents
end
