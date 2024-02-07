# frozen_string_literal: true

require "test_helper"

class TestBaseObject < Minitest::Test
  def test_object_type
    assert_equal "BaseObject", Skiwo::Hubspot::BaseObject.object_type
  end

  def test_it_respond_to_find
    assert_respond_to Skiwo::Hubspot::BaseObject, :find
  end

  def test_it_respond_to_create
    assert_respond_to Skiwo::Hubspot::BaseObject, :create
  end

  def test_it_respond_to_update_
    assert_respond_to Skiwo::Hubspot::BaseObject, :update
  end

  def test_it_returns_properties_for_object_type
    VCR.use_cassette("basic_object/properties") do
      properties, _error = Skiwo::Hubspot::BaseObject.properties(object_type: "Contact")
      refute_empty properties
    end
  end
end
