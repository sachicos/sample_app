module SessionsHelper
  
  def log_in(user)
    session[:user_id] = user.id
    # サーバの中と、ブラウザの中のcoockieにも保存している
  end
  
  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id # signed(暗号化してあれば復号化、暗号化してなければ暗号化)
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # def current_user
  #   if session[:user_id]
  #     @current_user ||= User.find_by(id: session[:user_id])
  #   end
  #   #User.find_by(id: session[:user_id])
  #   # インスタンス変数 ... 1回サーバにリクエストが飛んで、レスポンスが返ってくるまで生きている
  # end
  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])# user_id = session[:user_id], if user_id nil?
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      # raise#強制的にエラーを発生させる（テスト網羅性）
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token]) #コネクション切れていたら、クッキーに入っているか
        log_in user
        @current_user = user
      end
    end
    #最後に実行したものを返す？ ＞ nilが返る
  end
  
  # # 渡されたユーザーがカレントユーザーであればtrueを返す(nilガード,nilチェック)
  # def current_user?(user)
  #   redirect_to(root_url) unless current_user?(@user)
  # end
  # 渡されたユーザーがカレントユーザーであればtrueを返す
  def current_user?(user)
    user && user == current_user
  end
  

  def logged_in?
    !current_user.nil?
  end
  
  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)#１回目のログアウトでcurrent_userはnilに。
    session.delete(:user_id)
    @current_user = nil
  end
  
  
  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end