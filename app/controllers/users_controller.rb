class UsersController < ApplicationController
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
      # Success (valid params)
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      # Failure ( not valid params)
      render "new"
      
    end
  end
  
  
  private #　ここから下が意味合いがprivateになる（このファイル内でしか使えない）
  
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
