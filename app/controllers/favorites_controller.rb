class FavoritesController < ApplicationController

  def create
    news = News.find(params[:news_id])
    current_user.favorite_news << news
    redirect_to root_path, notice: 'いいねしました。'
  end

  def destroy
    news = News.find(params[:news_id])
    current_user.favorite_news.delete(news)
    redirect_to root_path, notice: 'いいねを取り消しました。'
  end
end
