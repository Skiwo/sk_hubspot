# frozen_string_literal: true

require "test_helper"

class TestDeal < Minitest::Test
  def test_that_it_finds_a_deal_by_id
    VCR.use_cassette("deals/find_one") do
      deal, _error = Skiwo::Hubspot::Deal.find("17521849182")
      assert_equal "17521849182", deal.id
    end
  end

  def test_that_it_returns_associated_companies
    VCR.use_cassette("deals/list_companies") do
      deal, _error = Skiwo::Hubspot::Deal.find("17521849182")
      assert_kind_of Skiwo::Hubspot::Company, deal.companies.first
    end
  end

  def test_that_it_returns_associated_contacts
    VCR.use_cassette("deals/list_contacts") do
      deal, _error = Skiwo::Hubspot::Deal.find("17521849182")
      assert_kind_of Skiwo::Hubspot::Contact, deal.contacts.first
    end
  end

  def test_that_it_creates_one_deal
    skip
    VCR.use_cassette("contacts/create_one") do
      contact, _error = Skiwo::Hubspot::Contact.create(properties: basic_attributes)
      assert_equal basic_attributes[:email], contact.email
    end
  end

  private

  def basic_attributes
    {
      firstname: Faker::Name.first_name,
      lastname: Faker::Name.last_name,
      email: "generic.testuser@skiwo.com",
      phone: Faker::PhoneNumber.cell_phone_with_country_code
    }
  end

  # Sample contact provided by Hubspot
  def sample_contact
    {
      hs_object_id: 1,
      firstname: "Maria",
      lastname: "Johnson (Sample Contact)",
      email: "emailmaria@hubspot.com"
    }
  end
end
