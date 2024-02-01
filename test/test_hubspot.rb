# frozen_string_literal: true

require "test_helper"

class TestHubspot < Minitest::Test
  def test_it_respond_to_client
    assert_respond_to Skiwo::Hubspot, :client
  end

  def test_it_respond_to_crm
    assert_respond_to Skiwo::Hubspot, :crm
  end
end
