require 'test_helper'

class RenderControllerTest < ActionController::TestCase
  test "should get render" do
    get :render
    assert_response :success
  end

end
