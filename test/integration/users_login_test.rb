require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    # テスト用のDBから引っ張る
    @user = users(:michael)
  end
  
  # test "login with invalid information" do
  #   get login_path
  #   assert_template 'sessions/new'
  #   post login_path, params: { session: { email: "", password:  } }
  #   assert_template 'sessions/new'
  #   assert_not flash.empty?# 消えてないべきである
  #   get root_path
  #   assert flash.empty? #消えてるべきである
  # end
  test "login with valid email/invalid password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email:    @user.email,
                                          password: "invalid" } }
    assert_not is_logged_in? # ログイン失敗しているので、ログインしてないはず
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path # deleteリクエストを /logoutに送る
    assert_not is_logged_in? # ログアウトしたのでログインしてないはず
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path #もう見れないよね
    assert_select "a[href=?]", logout_path,      count: 0 #もう見れないよね
    assert_select "a[href=?]", user_path(@user), count: 0 #もう見れないよね
  end
end
