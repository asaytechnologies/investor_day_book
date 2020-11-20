# frozen_string_literal: true

class Quote < ApplicationRecord
  include Sourceable

  belongs_to :security

  monetize :price_cents
end
