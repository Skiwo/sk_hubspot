# frozen_string_literal: true

require "json"

module Skiwo
  module Hubspot
    class ApiError < StandardError # :nodoc:
      attr_reader :code

      def initialize(code:, message:)
        super(message)
        @code = code
      end

      def self.with(error)
        begin
          message = JSON.parse(error.response_body).fetch("message")
        rescue JSON::ParserError
          message = { status: "error", message: error.message }
        end
        new(code: error.code, message:)
      end
    end
  end
end
