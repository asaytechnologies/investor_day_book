# frozen_string_literal: true

Bugsnag.configure do |config|
  config.api_key = Rails.application.credentials.fetch(:bugsnag_api_key)
  config.notify_release_stages = ['production']
end
