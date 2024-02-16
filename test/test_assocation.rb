# frozen_string_literal: true

require "test_helper"

CrmObjectDummy = Struct.new(:object_type, :id)

class TestAssociation < Minitest::Test
  def test_it_guesses_association_type_from_object_type
    contact = CrmObjectDummy.new("contact", 1)
    company = CrmObjectDummy.new("company", 1)
    association = Skiwo::Hubspot::Association.new(from: contact, to: company)
    assert_equal 279, association.type
  end

  def test_it_fails_without_type
    contact = CrmObjectDummy.new("contact", 1)
    assert_raises ArgumentError do
      Skiwo::Hubspot::Association.new(to: contact)
    end
  end

  def test_it_finds_association_type_from_type_name
    contact = CrmObjectDummy.new("company", 1)
    association = Skiwo::Hubspot::Association.new(to: contact, type: "company_to_contact")
    assert_equal 280, association.type
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
