# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Hubspot CRM Line Item
    #
    # Line items are individual instances of products
    class LineItem < Skiwo::Hubspot::CrmObject
      OBJECT_TYPE_ID = "0-8"

      def self.object_type_id
        OBJECT_TYPE_ID
      end

      def self.default_properties
        super + %w[name description price quantity amount currency
                   hs_sku hs_recurring_billing_period hs_product_id]
      end
    end
  end
end
