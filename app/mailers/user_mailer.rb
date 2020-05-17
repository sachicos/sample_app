class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  #@user.send_reset_email
  #UserMailer.password_reset(self).deliver_now
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
