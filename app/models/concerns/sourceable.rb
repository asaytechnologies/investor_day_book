# frozen_string_literal: true

module Sourceable
  extend ActiveSupport::Concern

  MOEX = 'moex'

  included do
    enum source: {
      MOEX => 0
    }
  end
end
