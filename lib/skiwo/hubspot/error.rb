# frozen_string_literal: true

require "json"

module Skiwo
  module Hubspot
    class Error < StandardError # :nodoc:
      attr_reader :code, :message

      def initialize(code:, message:)
        super
        @code = code
        @messag = message
      end

      def self.with_api_error(error)
        begin
          message = JSON.parse(error.message)
        rescue JSON::ParserError
          message = { status: "error", message: error.message }
        end
        new(code: error.code, message: message)
      end
    end
  end
end
