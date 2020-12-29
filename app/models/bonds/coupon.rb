# frozen_string_literal: true

module Bonds
  class Coupon < ApplicationRecord
    self.table_name = :bonds_coupons

    belongs_to :quote
  end
end
