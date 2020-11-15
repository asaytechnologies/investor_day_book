# frozen_string_literal: true

module Users
  class Account < ApplicationRecord
    self.table_name = :users_accounts

    belongs_to :user
  end
end
