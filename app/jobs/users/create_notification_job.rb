# frozen_string_literal: true

module Users
  class CreateNotificationJob < ApplicationJob
    queue_as :default

    def perform(id:)
      Users::CreateNotificationService.call(id: id)
    end
  end
end
