# frozen_string_literal: true

class Portfolio < ApplicationRecord
  belongs_to :user

  has_many :positions, class_name: 'Users::Position', inverse_of: :portfolio, dependent: :destroy
end
