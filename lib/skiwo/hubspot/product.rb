# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Hubspot CRM Product
    #
    # Product is for example a Manymore Price Plan
    class Product < Skiwo::Hubspot::CrmObject
      OBJECT_TYPE_ID = "0-7"

      def self.object_type_id
        OBJECT_TYPE_ID
      end

      def self.default_properties
        super + %w[name price hs_sku description hs_cost_of_goods_sold
                   hs_recurring_billing_period platform_uid platform_url]
      end

      def self.find_by_name(email, &block)
        results, error = search(name:)
        respond_with(response: results.first, error:, &block)
      end
    end
  end
end
