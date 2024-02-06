# frozen_string_literal: true

require "test_helper"

class TestClient < Minitest::Test
  def test_it_initializes_with__hubspot_access_token
    ENV["HUBSPOT_TOKEN"] = "123"
    client = Skiwo::Hubspot::Client.new

    assert_equal "123", client.access_token
  end

  def test_it_delegates_crm
    client = Skiwo::Hubspot::Client.new
    refute_nil client.crm
  end
end
