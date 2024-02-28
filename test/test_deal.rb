# frozen_string_literal: true

require "test_helper"

class TestDeal < Minitest::Test
  def test_that_it_finds_a_deal_by_id
    VCR.use_cassette("deals/find_one") do
      deal, _error = Skiwo::Hubspot::Deal.find(sample_deal[:hs_object_id])
      assert_equal sample_deal[:hs_object_id], deal.id
    end
  end

  def test_that_it_returns_associated_companies
    VCR.use_cassette("deals/list_companies") do
      deal, _error = Skiwo::Hubspot::Deal.find(sample_deal[:hs_object_id])
      assert_kind_of Skiwo::Hubspot::Company, deal.companies.first
    end
  end

  def test_that_it_returns_associated_contacts
    VCR.use_cassette("deals/list_contacts") do
      deal, _error = Skiwo::Hubspot::Deal.find(sample_deal[:hs_object_id])
      assert_kind_of Skiwo::Hubspot::Contact, deal.contacts.first
    end
  end

  def test_that_it_creates_one_deal
    VCR.use_cassette("deals/create_one") do
      contact = Skiwo::Hubspot::Contact.find(1) { |err| puts err }
      company = Skiwo::Hubspot::Company.find("19266541416") { |err| puts err }
      associations = []
      associations << Skiwo::Hubspot::Association.new(to: contact, type: "deal_to_contact").to_h
      associations << Skiwo::Hubspot::Association.new(to: company, type: "deal_to_company").to_h

      deal, _error = Skiwo::Hubspot::Deal.create(associations: associations, properties: basic_attributes)
      assert_equal basic_attributes[:dealname], deal.dealname
    end
  end

  private

  def basic_attributes
    {
      dealname: "Test Deal via API",
      amount: "1000.00",
      pipeline: "3954956",
      dealstage: "13253661",
      hubspot_owner_id: "609225610"
    }
  end

  def sample_deal
    {
      hs_object_id: "17767522592"
    }
  end
end
