# frozen_string_literal: true

class Quote < ApplicationRecord
  include Sourceable

  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  belongs_to :security

  monetize :price_cents
end
