# frozen_string_literal: true

require "test_helper"

class TestfCompanyToContactAssociation < Minitest::Test
  def test_it_creates_association
    VCR.use_cassette("associations/create_company_to_contact") do
      skip
      company, _error = Skiwo::Hubspot::Company.find("9406789183")
      contact, _error = Skiwo::Hubspot::Contact.find("1")
      association = Skiwo::Hubspot::CompanyToContactAssociation.new(from_object: company, to_object: contact)

      result, _error = association.save
      refute_nil result
    end
  end
end
