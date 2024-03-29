# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Base class for Hubspot's CRM Objects
    #
    #  * +:object+ - A Hubspot Crm Object
    #
    # It will delegate methods to the crm object.
    class CrmObject
      extend Skiwo::Hubspot::CrmApi

      attr_reader :crm_object
      attr_accessor :errors

      class << self
        def object_type_id
          fail NotImplementedError, "#{name} does not have a object_type_id"
        end

        def inherited(klass)
          super
          children << klass
        end

        def for(object_type_id)
          children.find { |crm_klass| crm_klass.object_type_id == object_type_id }
        end

        private

        def children
          @children ||= []
        end
      end

      def initialize(object)
        @crm_object = object
        @errors = []
      end

      def object_type
        self.class.object_type
      end

      def update(properties)
        response, error = self.class.update(id, properties:)

        if error
          errors << error
          false
        else
          @crm_object = response
          true
        end
      end

      def delete
        _response, error = self.class.delete(id)

        if error
          errors << error
          false
        else
          @crm_object.archived = true
          true
        end
      end

      ##
      # Loads the associated objects
      # Any errors will be added to the instance's errors.
      #
      #   * +:asscociated+ - Skiwo::Hubsport::CrmObject
      #
      # returns list of associated objects
      def load_associated(associated)
        associations = Skiwo::Hubspot::Association.list(
          from_object_type: self.class.object_type,
          to_object_type: associated.object_type,
          id:
        ) { |err| errors << err }

        if associations.any?
          ids = associations.first.to.map(&:to_object_id)

          result = ids.map do |associated_id|
            associated.find(associated_id) { |err| errors << err }
          end
          result.compact
        else
          []
        end
      end

      def ==(other)
        super || (
          self.class == other.class &&
          !id.nil? &&
          id == other.id
        )
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
    end
  end
end
