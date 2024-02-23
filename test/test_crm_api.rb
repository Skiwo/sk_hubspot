# frozen_string_literal: true

require "test_helper"

class CrmDummy
  extend Skiwo::Hubspot::CrmApi
end

class TestCrmApi < Minitest::Test
  def test_it_respond_to_object_type
    assert_respond_to CrmDummy, :object_type
  end

  def test_it_respond_to_find
    assert_respond_to CrmDummy, :find
  end

  def test_it_respond_to_search
    assert_respond_to CrmDummy, :search
  end

  def test_it_respond_to_find_by_platform_uid
    assert_respond_to CrmDummy, :find_by_platform_uid
  end

  def test_it_respond_to_default_properties
    assert_respond_to CrmDummy, :default_properties
  end

  def test_it_respond_to_properties
    assert_respond_to CrmDummy, :properties
  end

  def test_it_respond_to_create
    assert_respond_to CrmDummy, :create
  end

  def test_it_respond_to_update
    assert_respond_to CrmDummy, :update
  end

  def test_it_respond_with_response_using_block
    error = nil
    response = CrmDummy.respond_with(response: "response", error: nil) { |e| error = e }
    assert_equal "response", response
    assert_nil error
  end

  def test_it_respond_with_response_without_block
    response, error = CrmDummy.respond_with(response: "response", error: nil)
    assert_equal "response", response
    assert_nil error
  end

  def test_it_yields_error_and_return_nil
    returned_error = nil
    error = Skiwo::Hubspot::ApiError.new(code: "error", message: "FAILED")
    response = CrmDummy.respond_with(response: "response", error: error) { |e| returned_error = e }
    assert_equal error, returned_error
    assert_nil response
  end

  def test_it_respond_with_nil_and_error
    error = Skiwo::Hubspot::ApiError.new(code: "error", message: "FAILED")
    response, returned_error = CrmDummy.respond_with(response: "response", error: error)
    assert_equal error, returned_error
    assert_nil response
  end
end
