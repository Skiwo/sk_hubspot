# frozen_string_literal: true

require "active_support/inflector"
require "dotenv/load"

require_relative "hubspot/version"
require_relative "hubspot/client"
require_relative "hubspot/error"
require_relative "hubspot/base_object"
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
  end
end

# contact = Hubspot::Contact.find(id)
# if contact
#   do_stuff
# end

# attributes = { platform_id: '123', first_name: 'Han', last_name: 'Solo' }

# ## 1
# contact = Hubspot::Contact.new(attributes)
# if contact.save
#   go_on
# else
#   log_errors(contact.errors)
# end

# ## 2
# contact, errors = Hubspot::Contact.update(attributes)

# if errors
#   handle_errors
# end

# ## 3
# errors = []
# contact = Hubspot::Contact.update(attributes, errors)

# if errors.any?
#   handle_error
# end


# ## 4
# contact, errors = Hubspot::Contact.update(attributes)
# if not contact
#   deal_with_error
# end
