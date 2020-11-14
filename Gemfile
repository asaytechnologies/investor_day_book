# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'

# Use postgresql as the database for Active Record
gem 'pg', '1.2.3'

# Use Puma as the app server
gem 'puma', '~> 5.0.2'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'foreman', '0.87.2'
gem 'view_component', require: 'view_component/engine'
gem 'webpacker', '~> 5.2.1'

# Different
gem 'therubyracer', platforms: :ruby

# Auth
gem 'devise'

# localize
gem 'route_translator'

group :development, :test do
  # testing
  gem 'database_cleaner', '~> 1.8.5'
  gem 'factory_bot_rails', '~> 6.1.0'
  gem 'rspec-rails', '~> 4.0.1'
  # Static analysis
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  # N+1 query detector
  gem 'bullet', '~> 6.1.0'
end

group :development do
  gem 'letter_opener'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'json_spec'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end
