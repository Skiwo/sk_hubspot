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
      # Subclasses should override this method
      def default_properties
        %w[hs_object_id createdate lastmodifieddate]
      end

      ##
      # Find one record on Hubspot
      #
      #  * +:id+ - The object id of the record
      #  * +:options+ - Hash - { archived: true/false }
      #  * +:block+ - yields any error to the block
      #
      # returns a new instance of type Skiwo::Hubspot::CrmObject
      def find(id, options: {}, &block)
        options = { properties: default_properties, archived: false }.merge(options)
        error = nil
        response = basic_api.get_by_id(object_type: object_type, object_id: id, **options) do |err|
          error = Skiwo::Hubspot::ApiError.with(err)
        end

        respond_with(response: new(response), error: error, &block)
      end

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

      def find_by_platform_id(platform_id, &block)
        results, error = search(platform_id: platform_id)
        respond_with(response: results.first, error: error, &block)
      end

      ##
      # Update record on Hubspot
      #
      #   * +:id+ - The object id of the record
      #   * +:properties+ - Hash of properties
      #
      # returns a tuple with the updated record and any error
      def update(id, properties: {}, &block)
        body = { properties: properties }
        error = nil
        response = basic_api.update(object_type: object_type, object_id: id, body: body) do |err|
          error = Skiwo::Hubspot::ApiError.with(err)
        end

        respond_with(response: new(response), error: error, &block)
      end

      def properties(object_type: self.object_type, &block)
        properties, error = Skiwo::Hubspot.properties(object_type: object_type)
        respond_with(response: properties, error: error, &block)
      end

      ##
      # Create a new record on hubspot
      #
      #  * +:properties+ - Hash with properties
      #  * +:associations+ - Array of associations options
      #
      # returns a tuple with the new record and any error
      def create(properties:, associations: {}, &block)
        body = { properties: properties, associations: associations }
        error = nil
        response = basic_api.create(object_type: object_type, body: body) do |err|
          error = Skiwo::Hubspot::ApiError.with(err)
        end

        respond_with(response: new(response), error: error, &block)
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
