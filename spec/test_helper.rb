ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "factory_bot_rails"
require "webmock/minitest"
require "vcr"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Include FactoryBot methods
    include FactoryBot::Syntax::Methods

    # Add more helper methods to be used by all tests here...
  end
end

# Configure VCR
VCR.configure do |config|
  config.cassette_library_dir = "test/vcr_cassettes"
  config.hook_into :webmock
  
  # Filter out sensitive data
  config.filter_sensitive_data('<API_KEY>') { ENV['SUNSET_SUNRISE_API_KEY'] }
  
  # Allow real HTTP connections in some cases
  config.allow_http_connections_when_no_cassette = false
end

# Configure WebMock
WebMock.disable_net_connect!(allow_localhost: true)
