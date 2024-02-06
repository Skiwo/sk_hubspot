# frozen_string_literal: true

require "json"

class Skiwo::Hubspot::Error < StandardError
  attr_reader :code, :message

  def initialize(code:, message:)
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

