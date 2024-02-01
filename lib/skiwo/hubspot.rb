# frozen_string_literal: true

require "active_support/inflector"
require_relative "hubspot/version"
require_relative "hubspot/client"
require_relative "hubspot/base_object"

module Skiwo
  module Hubspot
    class Error < StandardError; end

    def self.client
      @client ||= Skiwo::Hubspot::Client.new
    end

    def self.crm
      client.crm
    end
  end
end
