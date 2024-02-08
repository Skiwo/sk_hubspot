# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Methods to query hubspot's crm api
    module CrmApi
      def object_type_id
        raise NotImplementedError
      end

      def object_type
        name.demodulize
      end

      ##
      # Returns an Array with the default properties
      # that will be returned when calling the hubspot api.
      #
      # Override this method in your own class
      def default_properties
        []
      end

      ##
      # Find one record on Hubspot
      #
      #  - id: The object id of the record
      #  - options: Hash - { archived: true/false }
      # returns record
      def find(id, options: {})
        error = nil
        response = basic_api.get_by_id(identifier_name.to_sym => id, **options) do |err|
          error = Skiwo::Hubspot::Error.with_api_error(err)
        end

        if error
          [nil, error]
        else
          [new(response), error]
        end
      end

      def search(properties: default_properties, **options)
        filters = options.map { |key, value| { propertyName: key.to_s, value: value, operator: "EQ" } }
        body = { properties: properties, filterGroups: [{ filters: filters }] }

        error = nil
        response = search_api.do_search(body: body) do |err|
          error = Skiwo::Hubspot::Error.with_api_error(err)
        end

        if error
          [nil, error]
        else
          results = response.results.map { |record| new(record) }
          [results, error]
        end
      end

      def find_by_platform_id(platform_id)
        results, error = search(platform_id: platform_id)

        if error
          [nil, error]
        else
          [results.first, error]
        end
      end

      ##
      # Update record on Hubspot
      #
      #   - id: The object id of the record
      #   - attributes: Hash of attributes
      #
      # returns tuple with the updated record and error
      def update(id, attributes: {})
        body = { properties: attributes }
        error = nil
        response = basic_api.update(identifier_name.to_sym => id, :body => body) do |err|
          error = Skiwo::Hubspot::Error.with_api_error(err)
        end

        if error
          [nil, error]
        else
          [new(response), nil]
        end
      end

      def properties(object_type: self.object_type)
        properties, error = Skiwo::Hubspot.properties(object_type: object_type)

        if error
          [nil, error]
        else
          [properties, nil]
        end
      end

      ##
      # Create a new record on hubspot
      #
      #  - attributes: Hash
      #
      # returns the new record
      def create(attributes:)
        body = { properties: attributes }
        error = nil
        response = basic_api.create(body: body) do |err|
          error = Skiwo::Hubspot::Error.with_api_error(err)
        end

        if error
          [nil, error]
        else
          [new(response), error]
        end
      end

      private

      def identifier_name
        @identifier_name ||= "#{object_type.downcase}_id"
      end

      def basic_api
        api_name = object_type.downcase.pluralize
        Skiwo::Hubspot.crm.public_send(api_name).basic_api
      end

      def search_api
        api_name = object_type.downcase.pluralize
        Skiwo::Hubspot.crm.public_send(api_name).search_api
      end
    end
  end
end
