require 'test_helper'

class BookControllerTest < ActionController::TestCase
  test "should get indexes" do
    get :indexes
    assert_response :success
  end

  test "should get get" do
    get :get
    assert_response :success
  end

end
