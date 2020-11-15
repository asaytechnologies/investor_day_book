# frozen_string_literal: true

module Users
  class Position < ApplicationRecord
    self.table_name = :users_positions

    belongs_to :user
    belongs_to :users_account, class_name: 'Users::Account'
    belongs_to :securitiable, polymorphic: true
  end
end
