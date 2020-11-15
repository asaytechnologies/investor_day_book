# frozen_string_literal: true

class Share < ApplicationRecord
  include Securitiable
  include Sectorable
end
