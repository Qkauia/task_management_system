# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
# require 'rspec/rails'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rspec/rails'
require 'webmock/rspec'
require 'factory_bot_rails'
require 'shoulda/matchers'

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

# Add additional requires below this line. Rails is not loaded until this point!

RSpec.configure do |config|
  # Factory Bot
  config.include FactoryBot::Syntax::Methods

  # Shoulda Matchers
  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  # WebMock
  WebMock.disable_net_connect!(allow_localhost: true)

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.use_transactional_fixtures = true

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.fixture_paths = [Rails.root.join('spec/fixtures').to_s]

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/6-0/rspec-rails
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods
end
