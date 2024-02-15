# frozen_string_literal: true

require "test_helper"

class TestHubspot < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil Skiwo::Hubspot::VERSION
  end

  def test_it_respond_to_client
    assert_respond_to Skiwo::Hubspot, :client
  end

  def test_it_respond_to_crm
    assert_respond_to Skiwo::Hubspot, :crm
  end

  def test_it_respond_to_configure
    assert_respond_to Skiwo::Hubspot, :configure
  end

  def test_it_configures_access_token
    Skiwo::Hubspot.configure do |config|
      config.access_token = "access-token"
    end

    assert_equal "access-token", Skiwo::Hubspot.configuration.access_token
  end

  def test_it_configures_default_deal_owner_id
    Skiwo::Hubspot.configure do |config|
      config.default_deal_owner_id = "owner-id"
    end

    assert_equal "owner-id", Skiwo::Hubspot.configuration.default_deal_owner_id
  end

  def test_it_returns_properties_for_contact
    VCR.use_cassette("hubspot/contact_properties") do
      properties, _error = Skiwo::Hubspot.properties(object_type: "Contact")
      refute_empty properties
    end
  end
end
