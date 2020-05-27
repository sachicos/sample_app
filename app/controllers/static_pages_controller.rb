class StaticPagesController < ApplicationController
  def home
    # => app/views/#{リソース名}/@{アクション名}.html.erb
    #ログインしている場合にかぎり（後置if文）
    #@micropost = current_user.microposts.build if logged_in?
    
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end
  
  def about
    # => app/views/static_pages/about.html.erb
  end
  
  def contact
  end
end
