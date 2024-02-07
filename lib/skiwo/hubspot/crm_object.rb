# frozen_string_literal: true

module Skiwo
  module Hubspot
    class CrmObject
      attr_accessor :id
      attr_accessor :properties
      attr_accessor :properties_with_history
      attr_accessor :created_at
      attr_accessor :updated_at
      attr_accessor :archived
      attr_accessor :archived_at
      attr_accessor :associations

      def initialize(object)
        @id = object.id
        @properties = object.properties
        @properties = object.properties
        @properties_with_history = object.properties_with_history
        @created_at = object.created_at
        @updated_at = object.updated_at
        @archived = object.archived
        @archived_at = object.archived_at
        @associations = object.associations
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
          [response, error]
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
          [response.results, error]
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
          [response, error]
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
          [response, nil]
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
