# frozen_string_literal: true

module Securitiable
  extend ActiveSupport::Concern

  included do
    has_many :quotes,
             as:         :securitiable,
             class_name: 'Exchanges::Quote',
             inverse_of: :securitiable,
             dependent:  :destroy
  end
end
