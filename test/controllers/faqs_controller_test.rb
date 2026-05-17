require "test_helper"

class FaqsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get faqs_new_url
    assert_response :success
  end

  test "should get create" do
    get faqs_create_url
    assert_response :success
  end

  test "should get destroy" do
    get faqs_destroy_url
    assert_response :success
  end

  test "should get update" do
    get faqs_update_url
    assert_response :success
  end

  test "should get edit" do
    get faqs_edit_url
    assert_response :success
  end
end
