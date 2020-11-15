# frozen_string_literal: true

module Sectorable
  extend ActiveSupport::Concern

  included do
    belongs_to :industry, optional: true
  end
end
