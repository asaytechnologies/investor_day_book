# frozen_string_literal: true

module Uploads
  class PerformUploadingJob < ApplicationJob
    queue_as :default

    def perform
      Uploads::PerformUploadingService.call
    end
  end
end
