# frozen_string_literal: true

module Portfolios
  class ImportInitialDataJob < ActiveJob::Base
    queue_as :default

    retry_on ActiveRecord::RecordNotFound, wait: 5.seconds, attempts: 5

    def perform(upload:)
      Positions::ImportService.call(
        source:    upload.source,
        file:      upload.file,
        portfolio: upload.user.portfolios.find_by!(guid: upload.guid)
      )
    end
  end
end
