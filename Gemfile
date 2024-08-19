# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.2.0"

gem "rails", "~> 7.1.3", ">= 7.1.3.4"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", ">= 4.0.1"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "bcrypt", "~> 3.1.7"
gem 'paranoia'
gem 'sassc'
gem 'kaminari'
gem 'kaminari-bootstrap'

group :development, :test do
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'faker'
  gem 'factory_bot_rails'
end

group :development do
  gem "web-console"
  # gem "rack-mini-profiler"
  # gem "spring"
end

group :test do
  gem 'rspec-rails', '6.1.1'
  gem 'shoulda-matchers'
  gem 'webmock'
  gem 'capybara', '3.40.0'
  gem 'selenium-webdriver', '4.10'
  gem 'webdrivers', '5.3.0'
  gem 'rails-controller-testing'
end
