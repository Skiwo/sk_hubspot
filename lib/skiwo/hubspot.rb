# frozen_string_literal: true

require "active_support/inflector"
require "dotenv/load"

require_relative "hubspot/version"
require_relative "hubspot/client"
require_relative "hubspot/api_error"
require_relative "hubspot/crm_api"
require_relative "hubspot/association"
require_relative "hubspot/contact_to_company_association"
require_relative "hubspot/company_to_contact_association"
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

    # TODO: fix responder or make documentation.
    # Internal use only?
    def self.properties(object_type:)
      error = nil
      properties = crm.properties.core_api.get_all(object_type: object_type) do |err|
        error = Skiwo::Hubspot::ApiError.with(err)
      end

      if error
        [nil, error]
      else
        [properties.results, nil]
      end
    end
  end
end
