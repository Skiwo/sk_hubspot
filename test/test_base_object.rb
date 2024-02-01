# frozen_string_literal: true

require "test_helper"

class TestBaseObject < Minitest::Test
  def test_that_it_has_object_type
    base_object = Skiwo::Hubspot::BaseObject.new
    assert_equal "BaseObject", base_object.object_type
  end
end
