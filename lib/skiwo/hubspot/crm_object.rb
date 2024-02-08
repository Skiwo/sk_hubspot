# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Base class for Hubspot's CRM Objects
    #
    # Accepts a Hubspot CRM Object.
    # It will delegate methods to the crm object.
    class CrmObject
      attr_reader :crm_object

      def initialize(object)
        @crm_object = object
      end

      def self.object_type_id
        raise NotImplementedError
      end

      def self.object_type
        name.demodulize
      end

      def self.default_properties
        {}
      end

      def method_missing(meth, *args, &block)
        return crm_object.public_send(meth, *args, &block) if crm_object.respond_to?(meth)
        return crm_object.properties.fetch(meth.to_s) if crm_object.properties.key?(meth.to_s)

        super
      end

      def respond_to_missing?(meth, include_private = false)
        if crm_object.respond_to?(meth) || crm_object.properties.key?(meth.to_s)
          true
        else
          super
        end
      end

      ##
      # Find one record on Hubspot
      #
      #  - id: The object id of the record
      #  - options: Hash - { archived: true/false }
      # returns record
      def self.find(id, options: {})
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

      def self.find_by_platform_id(platform_id)
        results, error = find_by(platform_id: platform_id)

        if error
          [nil, error]
        else
          [results.first, error]
        end
      end

      def self.find_by(properties: default_properties, **options)
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

      ##
      # Create a new record on hubspot
      #
      #  - attributes: Hash
      #
      # returns the new record
      def self.create(attributes:)
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

      ##
      # Update record on Hubspot
      #
      #   - id: The object id of the record
      #   - attributes: Hash of attributes
      #
      # returns tuple with the updated record and error
      def self.update(id, attributes: {})
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

      def self.properties(object_type: self.object_type)
        properties, error = Skiwo::Hubspot.properties(object_type: object_type)

        if error
          [nil, error]
        else
          [properties, nil]
        end
      end

      class << self
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
end
