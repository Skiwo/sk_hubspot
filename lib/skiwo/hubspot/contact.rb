# frozen_string_literal: true

module Skiwo
  module Hubspot
    class Contact < Skiwo::Hubspot::BaseObject
      OBJECT_TYPE_ID = "0-1"

      def self.object_type_id
        OBJECT_TYPE_ID
      end

      # Properties that will be returned in a response
      def self.default_properties
        %w[
          hs_object_id
          firstname
          lastname
          email
          phone
          createdate
          lastmodifieddate
          platform_id
          associatedcompanyid
        ]
      end
    end
  end
end
