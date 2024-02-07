# frozen_string_literal: true

module Skiwo
  module Hubspot
    class Company < Skiwo::Hubspot::CrmObject
      OBJECT_TYPE_ID = "0-2"

      def self.object_type_id
        OBJECT_TYPE_ID
      end

      def self.default_properties
        %w[
          hs_object_id
          name
          domain
          createdate
          lastmodifieddate
          platform_id
        ]
      end
    end
  end
end
