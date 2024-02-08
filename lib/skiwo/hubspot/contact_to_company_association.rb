# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Handles the Contact to Company Association
    #
    class ContactToCompanyAssociation < Skiwo::Hubspot::Association
      ASSOCIATION_TYPE_ID = 279

      def self.association_type_id
        ASSOCIATION_TYPE_ID
      end
    end
  end
end
