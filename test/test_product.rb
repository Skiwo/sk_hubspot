# frozen_string_literal: true

require "test_helper"

class TestProduct < Minitest::Test
  def test_that_it_finds_by_property_name
    VCR.use_cassette("products/find_by_property_name") do
      new_product, _error = Skiwo::Hubspot::Product.create(properties: basic_attributes)
      products, _error = Skiwo::Hubspot::Product.search(name: basic_attributes[:name])
      refute_empty products
      new_product.delete
    end
  end

  def test_that_it_creates_one_product
    VCR.use_cassette("products/create_one") do
      product, _error = Skiwo::Hubspot::Product.create(properties: basic_attributes)
      assert_equal basic_attributes[:name], product.name
      assert_equal basic_attributes[:price].to_s, product.price
      product.delete
    end
  end

  def test_that_it_updates_product
    VCR.use_cassette("products/update_one") do
      new_product, _error = Skiwo::Hubspot::Product.create(properties: basic_attributes)
      name = "#{new_product.name} Updated"

      product, _error = Skiwo::Hubspot::Product.update(new_product.id, properties: { name: })
      assert_equal name, product.name
      new_product.delete
    end
  end

  def test_that_it_finds_by_platform_uid
    VCR.use_cassette("products/find_by_platform_uid") do
      platform_uid = basic_attributes[:platform_uid]
      new_product, _error = Skiwo::Hubspot::Product.create(properties: basic_attributes)
      product, _error = Skiwo::Hubspot::Product.find_by_platform_uid(platform_uid)

      assert_equal platform_uid, product.platform_uid
      new_product.delete
    end
  end

  private

  def basic_attributes
    {
      name: "Product One [TEST]",
      price: 1000.00,
      platform_uid: "test-platform-uid",
      description: "Test Product in development",
      # hs_cost_of_goods_sold: 600.00,
      hs_recurring_billing_period: "P12M"
    }
  end
end
