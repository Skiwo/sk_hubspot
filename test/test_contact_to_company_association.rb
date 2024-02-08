# frozen_string_literal: true

require "test_helper"

class TestContactToCompanyAssociation < Minitest::Test
  def test_it_creates_association
    VCR.use_cassette("associations/create_contact_to_company") do
      contact, _error = Skiwo::Hubspot::Contact.find("1")
      company, _error = Skiwo::Hubspot::Company.find("9406789183")
      association = Skiwo::Hubspot::ContactToCompanyAssociation.new(from_object: contact, to_object: company)

      result, _error = association.save
      refute_nil result
    end
  end
end
