# frozen_string_literal: true

require "test_helper"

class TestCompany < Minitest::Test
  def test_that_it_finds_a_company_by_id
    VCR.use_cassette("companies/find_one") do
      company, _error = Skiwo::Hubspot::Company.find("9406789183")
      refute_nil company
      assert_equal "9406789183", company.id
    end
  end

  def test_that_it_creates_one_company
    VCR.use_cassette("companies/create_one") do
      company, _error = Skiwo::Hubspot::Company.create(properties: basic_attributes)
      refute_nil company
      assert_equal basic_attributes[:domain], company.properties["domain"]
    end
  end

  def test_that_it_updates_company
    VCR.use_cassette("companies/update_one") do
      object_id = sample_company[:hs_object_id]
      name = "#{sample_company[:name]} Updated"
      attributes = { name: name }

      company, _error = Skiwo::Hubspot::Company.update(object_id, properties: attributes)
      assert_equal attributes[:name], company.properties["name"]
    end
  end

  def test_that_it_fails_to_update_company_with_wrong_id
    VCR.use_cassette("companies/fails_to_update_with_wrong_id") do
      object_id = "999999999999"
      attributes = { name: Faker::Company.name }

      company, error = Skiwo::Hubspot::Company.update(object_id, properties: attributes)
      assert_nil company
      assert_equal 404, error.code
    end
  end

  def test_that_it_finds_by_platform_uid
    VCR.use_cassette("companies/find_by_platform_uid") do
      platform_uid = basic_attributes.fetch(:platform_uid)
      company, _error = Skiwo::Hubspot::Company.find_by_platform_uid(platform_uid)
      assert_equal platform_uid, company.properties["platform_uid"]
    end
  end

  def test_that_it_finds_by_org_number
    VCR.use_cassette("companies/find_by_org_number") do
      org_number = basic_attributes.fetch(:org_number)
      company, _error = Skiwo::Hubspot::Company.find_by_org_number(org_number)
      assert_equal org_number, company.properties["org_number"]
    end
  end

  def test_that_it_returns_associated_contacts
    VCR.use_cassette("companies/list_contacts") do
      company, _error = Skiwo::Hubspot::Company.find_by_platform_uid(basic_attributes[:platform_uid])
      assert_kind_of Skiwo::Hubspot::Contact, company.contacts.first
    end
  end

  def test_that_it_adds_a_contact
    VCR.use_cassette("companies/add_contact") do
      company, _error = Skiwo::Hubspot::Company.find("19019092085")
      contact, _error = Skiwo::Hubspot::Contact.find("1")
      assert company.add_contact(contact)
    end
  end

  private

  def basic_attributes
    {
      name: "Skiwo Sample Company",
      platform_uid: "test-platform-id",
      domain: "test.skiwo.com",
      org_number: "organisation-number"
    }
  end

  # Sample company
  def sample_company
    {
      hs_object_id: "19019092085",
      name: basic_attributes[:name]
    }
  end
end
