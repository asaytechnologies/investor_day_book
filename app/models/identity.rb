# frozen_string_literal: true

class Identity < ApplicationRecord
  belongs_to :user

  def self.find_with_oauth(auth)
    find_by(uid: auth.uid, provider: auth.provider)
  end
end
