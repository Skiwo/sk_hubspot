# frozen_string_literal = true

module Skiwo
  module Hubspot
    class BaseObject

      def object_type
        self.class.name.demodulize
      end

      private

      def basic_api
        name = self.class.name.pluralize
        Skiwo::Hubspot.crm.public_send(name).basic_api
      end
    end
  end
end
