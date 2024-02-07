# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "skiwo/hubspot"
require "hubspot-api-client"
require "minitest/autorun"
require "dotenv/load"
require "vcr"
require "faker"

# Silence the warnings generated when using hubspot-api-client
$VERBOSE = nil

# Hubspot checks for defined? Rails and not defined?(Rails.logger) && Rails.logger
# This is the fix for now
module Rails
  def self.logger
    Logger.new($stdout)
  end
end

# Configure VCR
VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/cassettes"
  config.hook_into :webmock
end

Faker::Config.locale = "nb-NO"