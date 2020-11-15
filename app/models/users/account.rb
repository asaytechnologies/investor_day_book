# frozen_string_literal: true

module Users
  class Account < ApplicationRecord
    self.table_name = :users_accounts

    belongs_to :user

    has_many :positions, class_name: 'Users::Position', inverse_of: :users_account, dependent: :destroy
  end
end
