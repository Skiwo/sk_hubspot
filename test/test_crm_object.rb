# frozen_string_literal: true

require "test_helper"

class TestCrmObject < Minitest::Test
  def test_object_type
    assert_equal "CrmObject", Skiwo::Hubspot::CrmObject.object_type
  end

  def test_it_respond_to_find
    assert_respond_to Skiwo::Hubspot::CrmObject, :find
  end

  def test_it_respond_to_create
    assert_respond_to Skiwo::Hubspot::CrmObject, :create
  end

  def test_it_respond_to_update
    assert_respond_to Skiwo::Hubspot::CrmObject, :update
  end

  def test_it_returns_properties_for_object_type
    VCR.use_cassette("crm_object/properties") do
      properties, _error = Skiwo::Hubspot::CrmObject.properties(object_type: "Contact")
      refute_empty properties
    end
  end
end
