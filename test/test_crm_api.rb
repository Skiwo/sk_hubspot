# frozen_string_literal: true

require "test_helper"

class CrmDummy
  extend Skiwo::Hubspot::CrmApi
end

class TestCrmApi < Minitest::Test
  def test_it_respond_to_object_type_id
    assert_respond_to CrmDummy, :object_type_id
  end

  def test_it_respond_to_object_type
    assert_respond_to CrmDummy, :object_type
  end

  def test_it_respond_to_find
    assert_respond_to CrmDummy, :find
  end

  def test_it_respond_to_search
    assert_respond_to CrmDummy, :search
  end

  def test_it_respond_to_find_by_platform_id
    assert_respond_to CrmDummy, :find_by_platform_id
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
end
