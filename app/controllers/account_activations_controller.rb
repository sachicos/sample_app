class AccountActivationsController < ApplicationController
  
  # GET account_activations/:id/edit
  def edit
    user = User.find_by(email: params[:email])# urlから取得できる情報は、「params」から引っ張り出すことができる
    if user && !user.activated? && user.authenticated?(:activation, params[:id])#activatedされてませんよね？（２回目以降のクリックは無効化invalid）
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
