# frozen_string_literal: true

class Bond < ApplicationRecord
  include Securitiable
  include Sectorable
end
