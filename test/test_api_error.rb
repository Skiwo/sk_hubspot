# frozen_string_literal: true

require "test_helper"

class TestApiError < Minitest::Test
  def test_it_respond_to_code
    assert_respond_to Skiwo::Hubspot::ApiError.new(code: nil, message: nil), :code
  end

  def test_it_respond_to_message
    assert_respond_to Skiwo::Hubspot::ApiError.new(code: nil, message: nil), :message
  end

  def test_it_builds_error_with_hubspot_api_error
    hubspot_error = nil
    VCR.use_cassette("api_errors/association_error") do
      Skiwo::Hubspot.crm.associations.v4.batch_api.create(
        from_object_type: "DontExist",
        to_object_type: "DontExist",
        body: {}
      ) { |err| hubspot_error = err }
    end
    api_error = Skiwo::Hubspot::ApiError.with(hubspot_error)

    refute_nil api_error.code
    refute_nil api_error.message
  end
end
