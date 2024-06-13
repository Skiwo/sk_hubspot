# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Hubspot CRM Company
    #
    # Companies store information about an individual business or organization.
    class Company < Skiwo::Hubspot::CrmObject
      OBJECT_TYPE_ID = "0-2"

      class << self
        def object_type_id
          OBJECT_TYPE_ID
        end

        def default_properties
          super + %w[
            name domain lifecyclestage hs_lead_status platform_uid platform_url
            platform_last_activity_date platform_industry platform_business_activity
            org_number
          ]
        end

        def find_by_org_number(org_number, &block)
          results, error = search(org_number:)
          respond_with(response: results.first, error:, &block)
        end
        alias find_by_organization_number find_by_org_number
      end

      def contacts
        @contacts ||= load_associated(Contact)
      end

      def deals
        @deals ||= load_associated(Deal)
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
