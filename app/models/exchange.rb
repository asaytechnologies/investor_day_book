# frozen_string_literal: true

class Exchange < ApplicationRecord
  include Sourceable

  has_many :quotes, class_name: 'Exchanges::Quote', inverse_of: :exchange, dependent: :destroy
end
