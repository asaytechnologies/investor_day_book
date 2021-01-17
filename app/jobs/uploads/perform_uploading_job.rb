# frozen_string_literal: true

module Uploads
  class PerformUploadingJob < ApplicationJob
    queue_as :default

    def perform
      Upload
        .where(completed: false)
        .where('created_at < ?', DateTime.now - 15.seconds)
        .each do |upload|
          portfolio = upload.user.portfolios.find_by(guid: upload.guid)
          next unless portfolio

          Positions::ImportService.call(
            source:    upload.source,
            file:      upload.file,
            portfolio: portfolio
          )
          upload.update(completed: true)
        end
    end
  end
end
