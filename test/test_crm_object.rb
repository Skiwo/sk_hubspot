# frozen_string_literal: true

require "test_helper"

# class DummyCrmObject < Skiwo::Hubspot::CrmObject; end

class TestCrmObject < Minitest::Test
  def test_it_respond_to_object_type_id
    assert_respond_to Skiwo::Hubspot::CrmObject, :object_type_id
  end

  def test_object_type
    assert_equal "CrmObject", Skiwo::Hubspot::CrmObject.new(nil).object_type
  end

  def test_it_returns_constant_for_object_type_id
    assert_equal Skiwo::Hubspot::Contact, Skiwo::Hubspot::CrmObject.for("0-1")
    assert_equal Skiwo::Hubspot::Company, Skiwo::Hubspot::CrmObject.for("0-2")
  end

  def test_it_initializes_errors
    assert_empty Skiwo::Hubspot::CrmObject.new(nil).errors
  end

  def test_it_respond_to_update
    assert_respond_to Skiwo::Hubspot::CrmObject.new(nil), :update
  end

  def test_it_returns_properties_for_object_type
    VCR.use_cassette("crm_object/properties") do
      properties, _error = Skiwo::Hubspot::CrmObject.properties(object_type: "Contact")
      refute_empty properties
    end
  end
end
