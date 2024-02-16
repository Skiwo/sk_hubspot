# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Hubspot CRM Company
    #
    # Companies store information about an individual business or organization.
    class Company < Skiwo::Hubspot::CrmObject
      OBJECT_TYPE_ID = "0-2"

      def self.object_type_id
        OBJECT_TYPE_ID
      end

      def self.default_properties
        super + %w[name domain lifecyclestage hs_lead_status platform_id platform_url
                   platform_last_activity_date platform_industry platform_business_activity org_id]
      end

      def contacts
        @contacts ||= load_associated(Contact)
      end

      ##
      # Add contact to company
      #
      #  * +:contact+ - Skiwo::Hubspot::Contact
      #
      # returns true or false
      def add_contact(contact)
        association = Skiwo::Hubspot::Association.new(from: self, to: contact)

        if association.save
          true
        else
          self.errors = errors + association.errors
          false
        end
      end
    end
  end
end
