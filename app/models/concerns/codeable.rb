# frozen_string_literal: true

module Codeable
  extend ActiveSupport::Concern

  MOEX = 'moex'

  included do
    enum code: {
      MOEX => 0
    }
  end
end
