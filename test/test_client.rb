# frozen_string_literal: true

require "test_helper"

class TestClient < Minitest::Test
  def test_it_initializes_with__hubspot_api_key
    ENV['HUBSPOT_TOKEN'] = '123'
    client = Skiwo::Hubspot::Client.new

    assert_equal '123', client.api_key
  end
end
