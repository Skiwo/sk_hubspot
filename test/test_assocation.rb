# frozen_string_literal: true

require "test_helper"

class TestAssociation < Minitest::Test
  def test_it_initializes_with_from_and_to_objects
    association = Skiwo::Hubspot::Association.new(from_object: nil, to_object: nil)
    assert_respond_to association, :from_object
    assert_respond_to association, :to_object
  end

  def test_it_respond_to_association_type_id
    assert_respond_to Skiwo::Hubspot::Association, :association_type_id
  end

  def test_it_list_associations
    VCR.use_cassette("associations/list_associations") do
      associations, _error = Skiwo::Hubspot::Association.list(
        from_object_type: "Contact",
        to_object_type: "Company",
        id: 1
      )
      refute_empty associations
    end
  end
end
