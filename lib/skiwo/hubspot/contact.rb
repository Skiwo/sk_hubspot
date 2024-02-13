# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Hubspot's CRM Contact
    #
    class Contact < Skiwo::Hubspot::CrmObject
      OBJECT_TYPE_ID = "0-1"

      def self.object_type_id
        OBJECT_TYPE_ID
      end

      # Properties that will be returned in a response
      def self.default_properties
        %w[hs_object_id firstname lastname email phone createdate
           lastmodifieddate platform_id associatedcompanyid]
      end

      def add_company(company)
        _association = Skiwo::Hubspot::ContactToCompanyAssociation.new(from_object: self, to_object: company)
      end

      def companies
        @companies ||= load_associated(Company)
      end
    end
  end
end
