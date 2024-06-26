# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Base class to handle associations between hubspot crm objects
    #
    #  * +:from+ - CrmObject
    #  * +:to+ - CrmObject
    #
    class Association
      ASSOCIATION_CATEGORY = "HUBSPOT_DEFINED"

      # Associtation Types
      CONTACT_TO_COMPANY  = 279
      COMPANY_TO_CONTACT  = 280
      DEAL_TO_CONTACT     = 3
      DEAL_TO_COMPANY     = 341
      DEAL_TO_LINE_ITEM   = 19
      DEAL_TO_PRODUCT     = 630
      LINE_ITEM_TO_DEAL   = 20

      attr_accessor :from_object, :to_object, :type, :category, :errors

      def initialize(to:, type: nil, from: nil, category: ASSOCIATION_CATEGORY)
        @from_object = from
        @to_object = to
        @type = get_type(type)
        @category = category
        @errors = []
      end

      def self.association_types
        @association_types ||= {
          "contact_to_company" => CONTACT_TO_COMPANY,
          "company_to_contact" => COMPANY_TO_CONTACT,
          "deal_to_contact" => DEAL_TO_CONTACT,
          "deal_to_company" => DEAL_TO_COMPANY,
          "deal_to_line_item" => DEAL_TO_LINE_ITEM,
          "deal_to_product" => DEAL_TO_PRODUCT,
          "line_item_to_deal" => LINE_ITEM_TO_DEAL
        }
      end

      def association_types
        self.class.association_types
      end

      # TODO: it would be better if we had AssociationList
      # TODO: raise an error if to_object.nil?
      def to_h
        input = { "types": types, "to": { "id": to_object.id } }
        input["from"] = { "id": from_object.id } if from_object
        input
      end

      def save
        result, error = self.class.create(
          from_object:,
          to_object:,
          body: [to_h]
        )

        if result
          true
        else
          errors << error
          false
        end
      end

      def self.list(from_object_type:, to_object_type:, id:, &block)
        body = { inputs: [{ id: }] }
        error = nil
        response = batch_api.get_page(
          from_object_type:,
          to_object_type:,
          body:
        ) { |err| error = Skiwo::Hubspot::ApiError.with(err) }

        # TODO: move this to a shared module
        yield error and return if block && error
        return response.results if block

        if error
          [nil, error]
        else
          [response.results, nil]
        end
      end

      def self.create(from_object:, to_object:, body:, &block)
        error = nil
        body = { inputs: body }
        response = batch_api.create(
          from_object_type: from_object.object_type,
          to_object_type: to_object.object_type, body:
        ) do |err|
          error = Skiwo::Hubspot::ApiError.with(err)
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

      private

      def get_type(type)
        type_id = if defined?(type) == "constant"
                    type
                  elsif type.is_a? String
                    association_types[type]
                  else
                    guess_type
                  end

        fail ArgumentError, "Association type not found" unless type_id

        type_id
      end

      # TODO: refactor the call to downcase, this method knows to much
      def guess_type
        type_name = "#{from_object&.object_type&.downcase}_to_#{to_object&.object_type&.downcase}"
        association_types[type_name]
      end

      # TODO: rename this method
      def types
        [
          {
            "associationCategory": category,
            "associationTypeId": type
          }
        ]
      end
    end
  end
end
