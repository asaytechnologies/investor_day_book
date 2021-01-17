# frozen_string_literal: true

require 'sidekiq/web'
Sidekiq::Web.app_url = '/'

return unless Rails.env.production?

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(username),
    ::Digest::SHA256.hexdigest(Rails.application.credentials.dig(:sidekiq, :username))
  ) &
  ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(password),
    ::Digest::SHA256.hexdigest(Rails.application.credentials.dig(:sidekiq, :password))
  )
end
