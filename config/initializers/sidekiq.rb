# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq/web'

Sidekiq::Web.app_url = '/'

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'invest_plan', url: 'redis://127.0.0.1:6379/2' }
end

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'invest_plan', url: 'redis://127.0.0.1:6379/2' }
end

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
