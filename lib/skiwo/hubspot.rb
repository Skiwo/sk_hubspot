# frozen_string_literal: true

require "active_support/inflector"
require "dotenv/load"

require_relative "hubspot/version"
require_relative "hubspot/client"
require_relative "hubspot/error"
require_relative "hubspot/crm_object"
require_relative "hubspot/contact"
require_relative "hubspot/company"

module Skiwo
  module Hubspot # :nodoc:
    def self.client
      @client ||= Skiwo::Hubspot::Client.new
    end

    def self.crm
      client.crm
    end

    def self.properties(object_type:)
      error = nil
      properties = crm.properties.core_api.get_all(object_type: object_type) do |err|
        error = Skiwo::Hubspot::Error.with_api_error(err)
      end

      if error
        [nil, error]
      else
        [properties.results, nil]
      end
    end
  end
end
