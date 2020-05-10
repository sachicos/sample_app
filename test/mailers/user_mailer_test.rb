require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    user = users(:michael)#フィクスチャーからマイケルさんをひっぱる
    user.activation_token = User.new_token#トークン作成し、いれこむ
    mail = UserMailer.account_activation(user)#メールオブジェクトが返ってくる（これを精査する）
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded #「＠」のエスケープ(%40)
  end
end