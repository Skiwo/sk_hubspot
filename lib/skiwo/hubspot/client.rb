# frozen_string_literal = true
#
require 'hubspot-api-client'

module Skiwo
  module Hubspot
    class Client
      attr_reader :api_key

      def initialize(access_token: ENV['HUBSPOT_TOKEN'])
        @api_key = access_token
        @hubspot_client = ::Hubspot::Client.new(access_token: api_key)
      end

      def api_key=(new_api_key)
        @api_key = new_api_key
        @hubspot_client = ::Hubspot::Client.new(access_token: api_key)
      end

      private
      attr_reader :hubspot_client
    end
  end
end
