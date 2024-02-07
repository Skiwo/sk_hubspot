# frozen_string_literal: true

require "test_helper"

class TestHubspot < Minitest::Test
  def test_it_respond_to_client
    assert_respond_to Skiwo::Hubspot, :client
  end

  def test_it_respond_to_crm
    assert_respond_to Skiwo::Hubspot, :crm
  end

  def test_it_returns_properties_for_contact
    VCR.use_cassette("hubspot/contact_properties") do
      properties, _error = Skiwo::Hubspot.properties(object_type: "Contact")
      refute_empty properties
    end
  end
end
