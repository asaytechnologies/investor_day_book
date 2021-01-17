# frozen_string_literal: true

class Upload < ApplicationRecord
  has_one_attached :file

  belongs_to :user

  after_commit :perform_uploading, on: :create

  private

  def perform_uploading
    case name
    when 'portfolio_initial_data' then Portfolios::ImportInitialDataJob.perform_now(upload: self)
    end
  end
end
