# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Handles the Company to Contact Association
    #
    class CompanyToContactAssociation < Skiwo::Hubspot::Association
      ASSOCIATION_TYPE_ID = 280

      def self.association_type_id
        ASSOCIATION_TYPE_ID
      end
    end
  end
end
