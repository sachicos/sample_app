module SessionsHelper
  
  def log_in(user)
    session[:user_id] = user.id
    # サーバの中と、ブラウザの中のcoockieにも保存している
  end
  
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
    #User.find_by(id: session[:user_id])
    # インスタンス変数 ... 1回サーバにリクエストが飛んで、レスポンスが返ってくるまで生きている
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
