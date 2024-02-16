# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Hubspot CRM Contact
    #
    # Contacts store information about an individual person.
    class Contact < Skiwo::Hubspot::CrmObject
      OBJECT_TYPE_ID = "0-1"

      def self.object_type_id
        OBJECT_TYPE_ID
      end

      def self.default_properties
        super + %w[firstname lastname email phone lifecyclestage hs_lead_status
                   associatedcompanyid platform_id platform_url]
      end

      ##
      # Add company to contact
      #
      #  * +:company+ - Skiwo::Hubspot::Company
      #
      # returns true or false
      def add_company(company)
        association = Skiwo::Hubspot::Association.new(from: self, to: company)

        if association.save
          true
        else
          self.errors = errors + association.errors
          false
        end
      end

      def companies
        @companies ||= load_associated(Company)
      end
    end
  end
end
