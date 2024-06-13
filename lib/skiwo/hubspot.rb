# frozen_string_literal: true

require "active_support/inflector"

require_relative "hubspot/version"
require_relative "hubspot/configuration"
require_relative "hubspot/client"
require_relative "hubspot/api_error"
require_relative "hubspot/crm_api"
require_relative "hubspot/association"
require_relative "hubspot/crm_object"
require_relative "hubspot/contact"
require_relative "hubspot/company"
require_relative "hubspot/deal"
require_relative "hubspot/product"
require_relative "hubspot/line_item"

module Skiwo
  module Hubspot # :nodoc:
    class << self
      attr_accessor :configuration

      def configure
        self.configuration ||= Configuration.new
        yield(configuration)
      end
    end

    def self.client
      @client ||= Skiwo::Hubspot::Client.new
    end

    def self.crm
      client.crm
    end

    def self.owners
      error = nil
      owners = crm.owners.owners_api.get_page(limit: 100, archived: false) do |err|
        error = Skiwo::Hubspot::ApiError.with(err)
      end

      if error
        [nil, error]
      else
        [owners.results, nil]
      end
    end

    # TODO: fix responder or make documentation.
    # Internal use only?
    def self.properties(object_type:)
      error = nil
      properties = crm.properties.core_api.get_all(object_type:) do |err|
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
