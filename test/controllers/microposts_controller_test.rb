require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @micropost = microposts(:orange)
  end

  #ログインしてないのにpostを送りつける->　はじかれるべき
  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  #ログインしてないのにdeleteを送りつける ->　はじかれるべき
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
  
  # ログインしていて、もし間違った投稿を削除しようとしたらできない
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))#マイケルでログイン
    micropost = microposts(:ants)#antsの投稿を削除しようとしても全体の数はかわってないですよ
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end
end