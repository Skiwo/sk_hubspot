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
      company, _error = Skiwo::Hubspot::Company.create(attributes: basic_attributes)
      refute_nil company
      assert_equal basic_attributes[:domain], company.properties["domain"]
    end
  end

  def test_that_it_updates_company
    VCR.use_cassette("companies/update_one") do
      object_id = sample_company[:hs_object_id]
      name = "#{sample_company[:name]} Updated"
      attributes = { name: name }

      company, _error = Skiwo::Hubspot::Company.update(object_id, attributes: attributes)
      assert_equal attributes[:name], company.properties["name"]
    end
  end

  def test_that_it_fails_to_update_company_with_wrong_id
    VCR.use_cassette("companies/fails_to_update_with_wrong_id") do
      object_id = "999999999999"
      attributes = { name: Faker::Company.name }

      company, error = Skiwo::Hubspot::Company.update(object_id, attributes: attributes)
      assert_nil company
      assert_equal 404, error.code
    end
  end

  def test_that_it_finds_by_platform_id
    VCR.use_cassette("companies/find_by_platform_id") do
      platform_id = basic_attributes.fetch(:platform_id)
      company, _error = Skiwo::Hubspot::Company.find_by_platform_id(platform_id)
      assert_equal platform_id, company.properties["platform_id"]
    end
  end

  private

  def basic_attributes
    {
      name: "Skiwo Sample Company",
      platform_id: "test-platform-id",
      domain: "test.skiwo.com"
    }
  end

  # Sample company
  def sample_company
    {
      hs_object_id: "19002270347",
      name: basic_attributes[:name]
    }
  end
end
