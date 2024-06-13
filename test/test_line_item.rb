# frozen_string_literal: true

require "test_helper"

class TestLineItem < Minitest::Test
  def test_it_creates_a_line_item_from_product_id
    VCR.use_cassette("line_items/create_line_item_from_product_id") do
      product, _error = Skiwo::Hubspot::Product.create(properties: product_attributes)
      line_item, _error = Skiwo::Hubspot::LineItem.create(
        properties: {
          hs_product_id: product.id,
          quantity: 1
        }
      )

      assert_equal line_item.name, product.name
      assert_equal line_item.price, product.price
      assert_equal line_item.quantity.to_i, 1

      product.delete
      line_item.delete
    end
  end

  def test_it_creates_deal_with_line_item
    VCR.use_cassette("line_items/deal_with_line_item") do
      associations = []
      product, _error = Skiwo::Hubspot::Product.create(properties: product_attributes)
      line_item, _error = Skiwo::Hubspot::LineItem.create(
        associations:,
        properties: {
          hs_product_id: product.id,
          quantity: 1,
          recurringbillingfrequency: "annually"
        }
      )

      associations << Skiwo::Hubspot::Association.new(to: line_item, type: "deal_to_line_item").to_h
      deal, _error = Skiwo::Hubspot::Deal.create(
        associations:,
        properties: deal_attributes.merge(amount: line_item.price)
      )

      assert_equal deal.amount, line_item.price

      product.delete
      line_item.delete
      deal.delete
    end
  end

  private

  def deal_attributes
    {
      dealname: "Test Deal via API",
      pipeline: "2016162",
      dealstage: "166509134"
    }
  end

  def product_attributes
    {
      name: "[TEST] Product One",
      price: 1000.0,
      platform_uid: "test-platform-uid",
      description: "Test Product in development",
      # hs_cost_of_goods_sold: 600.00,
      hs_recurring_billing_period: "P12M"
    }
  end
end
