# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Base class to handle associations between hubspot crm objects
    #
    #  - from_object: CrmObject
    #  - to_object: CrmObject
    #
    class Association
      ASSOCIATION_CATEGORY = "HUBSPOT_DEFINED"

      attr_accessor :from_object, :to_object

      def initialize(from_object:, to_object:)
        @from_object = from_object
        @to_object = to_object
      end

      def self.association_type_id
        raise NotImplementedError, "#{name} does not have a association_type_id"
      end

      def self.association_category
        ASSOCIATION_CATEGORY
      end

      def to_h
        { inputs: [
          { "types": [
              {
                "associationCategory": self.class.association_category,
                "associationTypeId": self.class.association_type_id
              }
            ],
            "from": { "id": from_object.id },
            "to": { "id": to_object.id } }
        ] }
      end

      def save
        self.class.create(from_object: from_object, to_object: to_object, body: to_h)
      end

      def self.create(from_object:, to_object:, body:, &block)
        error = nil
        response = batch_api.create(
          from_object_type: from_object.object_type,
          to_object_type: to_object.object_type, body: body
        ) do |err|
          error = Skiwo::Hubspot::Error.with_api_error(err)
        end

        yield error and return if block && error

        if error
          [nil, error]
        else
          [response, nil]
        end
      end

      def self.batch_api
        Skiwo::Hubspot.crm.associations.v4.batch_api
      end
    end
  end
end
