# frozen_string_literal: true

module Sourceable
  extend ActiveSupport::Concern

  MOEX = 'moex'
  TINKOFF = 'tinkoff'

  included do
    enum source: {
      MOEX    => 0,
      TINKOFF => 1
    }
  end
end
