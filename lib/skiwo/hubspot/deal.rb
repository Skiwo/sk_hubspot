# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Hubspot CRM Deal
    #
    # Deals represent revenue opportunities with a contact or company.
    # They’re tracked through pipeline stages, resulting in the deal being won or lost.
    class Deal < CrmObject
      OBJECT_TYPE_ID = "0-3"

      def self.object_type_id
        OBJECT_TYPE_ID
      end

      def self.default_properties
        super + %w[dealname amount pipeline closedate dealstage
                   hubspot_owner_id platform_id platform_url]
      end

      def contacts
        @contacts ||= load_associated(Contact)
      end

      def companies
        @companies ||= load_associated(Company)
      end
    end
  end
end
