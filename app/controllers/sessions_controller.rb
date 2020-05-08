class SessionsController < ApplicationController
  def new
    # x @sessin = Session.new
    # o scope: :session + url: login_path
  end
  
  # POST /login
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Success
      # session[:user_id] = user.id
      log_in user # ログインする
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # remember user # ユーザを永続的に保存(クッキーの中に保存、ユーザIDをいれ、DBのdigestの中に書き込む)
      redirect_back_or user
    else
      # Failure
      #alert-denger 赤色のフラッシュ
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
      # redirect_to vs render ：呼び出している物が違う！
      # => flash ... 次のリクエストが来るまでは、保持する
      # GET /user/1 => show template
      # render 'new' ... リクエストを送っているわけではなく、
      #                  今いるところから直接newテンプレートを呼び出してくるだけ(まだ０回目)
      #
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url # root_path でもいいけど、慣習。
  end
  
end
