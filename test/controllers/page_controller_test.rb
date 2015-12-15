require 'test_helper'

class PageControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get indexes" do
    get :indexes
    assert_response :success
  end

end
