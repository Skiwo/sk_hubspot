# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Methods to query hubspot's crm api
    module CrmApi
      def object_type
        name.demodulize
      end

      ##
      # Returns an Array with the default properties
      # that will be returned when calling the hubspot api.
      #
      # Classes that uses this module should override this method.
      def default_properties
        %w[hs_object_id createdate lastmodifieddate]
      end

      ##
      # Find one record on Hubspot
      #
      #  * +:id+ - The object id of the record
      #  * +:options+ - Hash
      #  * +:block+ - yields any error to the block
      #
      # Options:
      #  * properties: Array of returned properties
      #  * archived: true/false
      #
      # With block:
      # returns the crm object if found
      # Without block:
      # Returns a tuple with [result_object, error]
      def find(id, options: {}, &block)
        options = { properties: default_properties, archived: false }.merge(options)
        error = nil
        response = basic_api.get_by_id(object_type: object_type, object_id: id, **options) do |err|
          error = Skiwo::Hubspot::ApiError.with(err)
        end

        respond_with(response: new(response), error: error, &block)
      end

      ##
      # Find some object by search criteria
      #
      #  * +:properties+ - The returned properties
      #  * +:options+ - Hash of search criteria
      #  * +:block+ - yields any error to the block
      #
      #  Options:
      #  * propertyName: name
      #  * value: value
      #  * operator: Only "EQ" is supported at this time
      #
      #  Example:
      #  .search(firstname: "Alice")
      #  => [{firstname: "Alice", lastname: "Malice"}, {firstname: "Alice"...}]
      #
      # With block:
      # returns list of objects that match the search criteria
      # Without block:
      # Returns a tuple with [result_objects, error]
      def search(properties: default_properties, **options, &block)
        filters = options.map { |key, value| { propertyName: key.to_s, value: value, operator: "EQ" } }
        body = { properties: properties, filterGroups: [{ filters: filters }] }

        error = nil
        response = search_api.do_search(object_type: object_type, body: body) do |err|
          error = Skiwo::Hubspot::ApiError.with(err)
        end

        results = response.results.map { |record| new(record) }
        respond_with(response: results, error: error, &block)
      end

      ##
      # Finds one object with platform id
      #
      # With block:
      # Returns the object if found
      # Without block:
      # Returns a tuple with [result_object, error]
      def find_by_platform_uid(platform_uid, &block)
        results, error = search(platform_uid: platform_uid)
        respond_with(response: results.first, error: error, &block)
      end

      ##
      # Update record on Hubspot
      #
      #   * +:id+ - The object id of the record
      #   * +:properties+ - Hash of properties
      #   * +:block+ - yields any error to the block
      #
      # With block:
      # Returns the updated object
      # Without block:
      # Returns a tuple with [result_object, error]
      def update(id, properties: {}, &block)
        body = { properties: properties }
        error = nil
        response = basic_api.update(object_type: object_type, object_id: id, body: body) do |err|
          error = Skiwo::Hubspot::ApiError.with(err)
        end

        respond_with(response: new(response), error: error, &block)
      end

      ##
      # Create a new record on hubspot
      #
      #  * +:properties+ - Hash with properties
      #  * +:associations+ - Array of associations options
      #  * +:block+ - yields any error to the block
      #
      # With block:
      # Returns the new object
      # Without block:
      # Returns a tuple with [result_object, error]
      def create(properties:, associations: {}, &block)
        body = { properties: properties, associations: associations }
        error = nil
        response = basic_api.create(object_type: object_type, body: body) do |err|
          error = Skiwo::Hubspot::ApiError.with(err)
        end

        respond_with(response: new(response), error: error, &block)
      end

      def properties(object_type: self.object_type, &block)
        properties, error = Skiwo::Hubspot.properties(object_type: object_type)
        respond_with(response: properties, error: error, &block)
      end

      def respond_with(response:, error:, &block)
        yield error and return if block && error
        return response if block

        if error
          [nil, error]
        else
          [response, nil]
        end
      end

      private

      def basic_api
        Skiwo::Hubspot.crm.objects.basic_api
      end

      def search_api
        Skiwo::Hubspot.crm.objects.search_api
      end
    end
  end
end
