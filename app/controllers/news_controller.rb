class NewsController < ApplicationController
  before_action :load_active_hash, only: [:index, :new, :create, :show, :edit]
  before_action :find_or_create_user, only: [:index, :create, :show, :edit]
  before_action :set_news, only: [:show, :destroy, :update]

  def index
    @news = News.all # すべてのニュース記事を取得
    @new_news = News.new # 新しいニュース記事を作成するためのインスタンス
  end

  def new
    @news = News.new
  end

  def create
    @news = News.new(news_params)
    @news.author_name = @user.username

    if @news.save
      redirect_to news_index_path, notice: '記事が作成されました'
    else
      render :new
    end
  end

  def show
    @new_news = News.new
  end

  def edit
    @news = News.find(params[:id])
    find_or_create_user
    respond_to do |format|
      format.html { render partial: 'news/edit_form', locals: { news: @news } }
      format.js
    end
  end

  def update
    if @news.update(news_params)
      redirect_to news_index_path, notice: '記事が更新されました'
    else
      render :edit
    end
  end

  def destroy
    @news.destroy
    redirect_to news_index_path, notice: '記事が削除されました'
  end

  private

  def load_active_hash
    @prefectures = ActiveHash::Prefecture.all
    @categories = ActiveHash::Category.all
  end

  def find_or_create_user
    ip_address = request.remote_ip
    @user = User.find_or_create_by(ip_address: ip_address) do |user|
      user.username = "Guest_#{User.count + 1}"
      user.address_id = nil
    end
  end

  def set_news
    @news = News.find(params[:id])
  end

  def news_params
    params.require(:news).permit(:title, :content, :prefecture_id, :category_id, images: [])
  end
end
