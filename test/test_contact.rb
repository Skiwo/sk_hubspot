# frozen_string_literal: true

require "test_helper"

class TestContact < Minitest::Test
  def test_that_it_finds_a_contact_by_id
    VCR.use_cassette("contacts/find_one") do
      contact, _error = Skiwo::Hubspot::Contact.find("1")
      assert_equal "1", contact.id
    end
  end

  def test_that_it_creates_one_contact
    VCR.use_cassette("contacts/create_one") do
      contact, _error = Skiwo::Hubspot::Contact.create(attributes: basic_attributes)
      assert_equal basic_attributes[:email], contact.properties["email"]
    end
  end

  def test_that_it_updates_contact
    VCR.use_cassette("contacts/update_one") do
      object_id = sample_contact.fetch(:hs_object_id)
      first_name = "#{sample_contact[:firstname]} Updated"
      platform_id = "this-is-a-test-platform-id"
      attributes = { firstname: first_name, platform_id: platform_id }

      contact, _error = Skiwo::Hubspot::Contact.update(object_id, attributes: attributes)
      assert_equal attributes[:firstname], contact.properties["firstname"]
      assert_equal attributes[:platform_id], contact.properties["platform_id"]
    end
  end

  def test_that_it_fails_to_update_contact_with_wrong_id
    VCR.use_cassette("contacts/fails_to_update_with_wrong_id") do
      object_id = "999999999999"
      attributes = basic_attributes
      attributes[:email] = Faker::Internet.email

      contact, error = Skiwo::Hubspot::Contact.update(object_id, attributes: basic_attributes)
      assert_nil contact
      assert_equal 404, error.code
    end
  end

  def test_that_it_finds_by_platform_id
    VCR.use_cassette("contacts/find_by_platform_id") do
      platform_id = "57244c78-6900-44bc-8c96-863ec1e2b44f"
      contact, _error = Skiwo::Hubspot::Contact.find_by_platform_id(platform_id)
      assert_equal platform_id, contact.properties["platform_id"]
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
