# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Hubspot's CRM Company
    #
    class Company < Skiwo::Hubspot::CrmObject
      OBJECT_TYPE_ID = "0-2"

      def self.object_type_id
        OBJECT_TYPE_ID
      end

      def self.default_properties
        %w[hs_object_id name domain createdate lastmodifieddate platform_id]
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
        association = Skiwo::Hubspot::CompanyToContactAssociation.new(from_object: self, to_object: contact)

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
