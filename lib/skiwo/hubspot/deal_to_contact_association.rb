# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Handles the Deal to Contact Association
    #
    class DealToContactAssociation < Skiwo::Hubspot::Association
      ASSOCIATION_TYPE_ID = 3

      def self.association_type_id
        ASSOCIATION_TYPE_ID
      end
    end
  end
end
