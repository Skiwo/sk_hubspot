# frozen_string_literal: true

module Skiwo
  module Hubspot
    ##
    # Configuration
    #
    # Skiwo::Hubspot.configure do |config|
    #   config.access_token = 'access-token'
    #   config.default_owner_id = 'some-id'
    # end
    class Configuration
      attr_accessor :access_token, :default_deal_owner_id
    end
  end
end
