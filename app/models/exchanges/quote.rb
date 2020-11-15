# frozen_string_literal: true

module Exchanges
  class Quote < ApplicationRecord
    self.table_name = :exchanges_quotes

    belongs_to :exchange
    belongs_to :securitiable, polymorphic: true

    monetize :price_cents
  end
end
