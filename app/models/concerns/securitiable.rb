# frozen_string_literal: true

module Securitiable
  extend ActiveSupport::Concern

  included do
    has_many :quotes,
             as:         :securitiable,
             class_name: 'Exchanges::Quote',
             inverse_of: :securitiable,
             dependent:  :destroy

    has_many :positions,
             as:         :securitiable,
             class_name: 'Users::Position',
             inverse_of: :securitiable,
             dependent:  :destroy
  end
end
