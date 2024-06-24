class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @news = News.find(params[:news_id])
    if current_user.favorite_news.include?(@news)
      redirect_to root_path, alert: 'すでにいいね済みです。'
    else
      current_user.favorite_news << @news
      redirect_to root_path, notice: 'いいねしました。'
    end
  end

  def destroy
    @news = News.find(params[:news_id])
    if current_user.favorite_news.include?(@news)
      current_user.favorite_news.delete(@news)
      redirect_to root_path, notice: 'いいねを取り消しました。'
    else
      redirect_to root_path, alert: 'いいねしていません。'
    end
  end
end