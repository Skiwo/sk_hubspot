# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Base class for Hubspot's CRM Objects
    #
    # Accepts a Hubspot CRM Object.
    # It will delegate methods to the crm object.
    class CrmObject
      extend Skiwo::Hubspot::CrmApi

      attr_reader :crm_object

      def initialize(object)
        @crm_object = object
      end

      class << self
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
