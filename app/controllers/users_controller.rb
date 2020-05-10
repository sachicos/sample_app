class UsersController < ApplicationController
  #actionの実行前に割り込み処理で実行する
  before_action :logged_in_user,#シンボル(メソッド名は基本シンボル記載)で書かれたメソッド名（logged_in_user）を呼び出してください 
                 only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update] #current_userが入るのはlogged_in_userのみ(ログインがおこなわれている前提の方が、シンプルなテストを書ける)
  before_action :admin_user,     only: :destroy
  
  # GET /users
  def index
    @users = User.paginate(page: params[:page])
  end
  
  # GET /users/:id
  def show
    # user  ローカル変数（アクション内のみで使用可能）
    @user = User.find(params[:id]) # インスタンス変数
    # @@user グローバル変数（使わない）
  end
  
  # GET/users/new
  def new
    @user = User.new
  end
  
  # POST /users (+ params) デフォルト
  def create
    @user = User.new(user_params)
    if @user.save
      # ユーザー登録したら、ログインされる
      @user.send_activation_email
      # UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      # Failure ( not valid params)
      render "new"
      
    end
  end
  
  # パッチリクエスとに反応するわけではない。パッチリクエストを送るためのformを生成するための
  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
    #デフォルトレンダー => app/views/users/edit.html.erb
  end

  #PAtCH /users/:id
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      # @user.errors <== ここにデータが入っている
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private #　ここから下が意味合いがprivateになる（このファイル内でしか使えない）
  
  # beforeアクション

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
  
  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
  
 # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
   # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
