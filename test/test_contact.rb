# frozen_string_literal: true

require "test_helper"

class TestContact < Minitest::Test
  def test_that_it_finds_a_contact_by_id
    VCR.use_cassette("contacts/find_one") do
      contact, _error = Skiwo::Hubspot::Contact.find("1")
      assert_equal "1", contact.id
    end
  end

  def test_that_it_finds_by_property_name
    VCR.use_cassette("contacts/find_by_property_name") do
      contacts, _error = Skiwo::Hubspot::Contact.search(firstname: "Jon")
      refute_empty contacts
      refute_nil contacts.first.email
    end
  end

  def test_it_finds_no_records
    VCR.use_cassette("contacts/search_returns_no_records") do
      contacts, _error = Skiwo::Hubspot::Contact.search(firstname: "Don't Exist")
      assert_empty contacts
    end
  end

  def test_that_it_creates_one_contact
    VCR.use_cassette("contacts/create_one") do
      contact, _error = Skiwo::Hubspot::Contact.create(properties: basic_attributes)
      assert_equal basic_attributes[:email], contact.email
    end
  end

  def test_that_it_updates_contact
    VCR.use_cassette("contacts/update_one") do
      object_id = sample_contact.fetch(:hs_object_id)
      first_name = "#{sample_contact[:firstname]} Updated"
      platform_uid = "this-is-a-test-platform-id"
      attributes = { firstname: first_name, platform_uid: }

      contact, _error = Skiwo::Hubspot::Contact.update(object_id, properties: attributes)
      assert_equal attributes[:firstname], contact.firstname
      assert_equal attributes[:platform_uid], contact.platform_uid
    end
  end

  def test_that_it_fails_to_update_contact_with_wrong_id
    VCR.use_cassette("contacts/fails_to_update_with_wrong_id") do
      object_id = "999999999999"
      attributes = basic_attributes
      attributes[:email] = Faker::Internet.email

      contact, error = Skiwo::Hubspot::Contact.update(object_id, properties: basic_attributes)
      assert_nil contact
      assert_equal 404, error.code
    end
  end

  def test_that_it_yields_with_error
    VCR.use_cassette("contacts/yields_with_error") do
      object_id = "999999999999"
      attributes = basic_attributes
      attributes[:email] = Faker::Internet.email

      error = nil
      contact = Skiwo::Hubspot::Contact.update(object_id, properties: basic_attributes) do |err|
        error = err
      end

      assert_nil contact
      assert_equal 404, error.code
    end
  end

  def test_that_it_finds_by_platform_uid
    VCR.use_cassette("contacts/find_by_platform_uid") do
      platform_uid = sample_contact[:platform_uid]
      contact, _error = Skiwo::Hubspot::Contact.find_by_platform_uid(platform_uid)
      assert_equal platform_uid, contact.platform_uid
    end
  end

  def test_that_it_finds_by_email
    VCR.use_cassette("contacts/find_by_email") do
      email = sample_contact[:email]
      contact, _error = Skiwo::Hubspot::Contact.find_by_email(email)
      assert_equal email, contact.email
    end
  end

  def test_that_it_returns_associated_companies
    VCR.use_cassette("contacts/list_companies") do
      contact, _error = Skiwo::Hubspot::Contact.find(sample_contact[:hs_object_id])
      assert_kind_of Skiwo::Hubspot::Company, contact.companies.first
    end
  end

  def test_that_it_adds_a_company
    VCR.use_cassette("contacts/add_company") do
      company, _error = Skiwo::Hubspot::Company.find("19266541416")
      contact, _error = Skiwo::Hubspot::Contact.find("1")
      assert contact.add_company(company)
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
      email: "emailmaria@hubspot.com",
      platform_uid: "this-is-a-test-platform-id"
    }
  end
end
