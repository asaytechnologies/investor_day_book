# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.3'

# Use postgresql as the database for Active Record
gem 'pg', '1.2.3'

# Use Puma as the app server
gem 'puma', '~> 5.2'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'foreman', '0.87.2'
gem 'view_component', require: 'view_component/engine'
gem 'webpacker', '~> 5.2'

# Different
gem 'therubyracer', platforms: :ruby

# Auth
gem 'devise'

# localize
gem 'route_translator'

# Money types
gem 'money-rails'

# DRY-RB ecosystem
gem 'dry-initializer', '~> 3.0'

# http client
gem 'faraday', '~> 1.3'
gem 'faraday_middleware', '~> 1.0'

# tinkoff invest api
gem 'tinkoff_invest'

# Background Jobs
gem 'redis-rails'

# Search engine
gem 'mysql2', '~> 0.4', platform: :ruby
gem 'thinking-sphinx', '~> 5.0'

# read xlsx files
gem 'creek'
gem 'roo-xls', '~> 1.2.0'

# error notifications
gem 'bugsnag', '~> 6.19.0'

# performance tracker
gem 'skylight', '~> 4.3.0'

# cron jobs
gem 'whenever', require: false

# active jobs adapter
gem 'que', git: 'https://github.com/kortirso/que'
gem 'que-web', '~> 0.9.3'

# Oauth authentication
gem 'omniauth', '~> 1.9.0'
gem 'omniauth-google-oauth2', '~> 0.8.0'
gem 'omniauth-vkontakte'
gem 'omniauth-yandex'

# recaptcha
gem 'recaptcha', require: 'recaptcha/rails'

# json api
gem 'jsonapi-serializer'
gem 'jwt'
gem 'oj'
gem 'oj_mimic_json'

group :development, :test do
  # Static analysis
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  # N+1 query detector
  gem 'bullet', '~> 6.1.0'
end

group :development do
  gem 'capistrano', '~> 3.15.0', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', '~> 1.6.0', require: false
  gem 'capistrano-rvm', require: false
  gem 'letter_opener'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner', '~> 1.8.5'
  gem 'factory_bot_rails', '~> 6.1.0'
  gem 'faker'
  gem 'json_spec'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 4.0.1'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'
end
