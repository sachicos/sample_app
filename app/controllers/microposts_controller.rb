class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url # => satic_pages#home
    else
      # 投稿する場所（失敗したとき）
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home' #viewだけ呼び出してて、homeアクションを呼び出しているわけではない
    end
  end
  
  # DElETE /microposts/:id
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    
    # 削除したときに、どこから削除したのかが変わる可能性がある (request.referrerはリクエストを送った元のページ)
    redirect_to request.referrer || root_url
  end
  
  private
  
    # ストロングパラメータ(関連付けされているから、ログイン情報はいらない、コンテントのみでOK)
    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end
    
    # 正しいユーザーだったら
    def correct_user
      # current_usr(自分が投稿した物) :id=>micropostのid(消したい投稿のid)
      # 自分の投稿したものの中に、消したい投稿のidがあるかどうか（全体の集合の中から、要素が入っているかどうか）
      @micropost = current_user.microposts.find_by(id: params[:id])
      # 入ってない=>消そうとしているものに対して、正しいユーザではない
      redirect_to root_url if @micropost.nil?
    end
end
