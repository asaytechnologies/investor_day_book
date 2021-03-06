# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'money-rails/test_helpers'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include OmniauthMacros,                  type: :controller
  config.extend ControllerMacros,                 type: :controller
  config.include Rack::Test::Methods, type: :request

  include Warden::Test::Helpers
  Warden.test_mode!
  config.after do
    Warden.test_reset!
  end
end
