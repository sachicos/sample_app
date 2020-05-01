require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path #login_pathに行ったら、レスポンスが返ってくる
    assert_response :success
  end

end
