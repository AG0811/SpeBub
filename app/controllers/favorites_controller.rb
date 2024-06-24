# app/controllers/favorites_controller.rb
class FavoritesController < ApplicationController
  before_action :set_news
  before_action :require_user

  def create
    if current_user.favorite_news << @news
      redirect_to root_path, notice: 'いいねしました。'
    else
      redirect_to root_path, alert: 'いいねできませんでした。'
    end
  end

  def destroy
    if current_user.favorite_news.delete(@news)
      redirect_to root_path, notice: 'いいねを取り消しました。'
    else
      redirect_to root_path, alert: 'いいねを取り消せませんでした。'
    end
  end

  private

  def set_news
    @news = News.find(params[:news_id])
  end

  def require_user
    redirect_to root_path, alert: 'ログインしてください。' unless current_user
  end
end
