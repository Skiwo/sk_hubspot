# frozen_string_literal = true
#
require 'hubspot-api-client'

module Skiwo
  module Hubspot
    class Client
      attr_reader :access_token

      def initialize(access_token: ENV['HUBSPOT_TOKEN'])
        @access_token = access_token
        set_hubspot_client
      end

      def access_token=(new_access_token)
        @access_token = new_access_token
        set_hubspot_client
      end

      def crm
        hubspot_client.crm
      end

      private
      attr_reader :hubspot_client

      def set_hubspot_client
        @hubspot_client = ::Hubspot::Client.new(access_token: access_token)
      end
    end
  end
end
