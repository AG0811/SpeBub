# app/controllers/news_controller.rb

class NewsController < ApplicationController
  before_action :load_active_hash, only: [:index, :new, :create, :show, :edit]
  before_action :find_or_create_user
  before_action :set_news, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]

  def index
    @news = News.order(created_at: :desc)
    @new_news = News.new
    @favorited_news_ids = current_user.favorite_news.pluck(:id) if current_user
  end

  def new
    @news = News.new
  end

  def create
    @news = News.new(news_params)
    @news.user_id = @user.id  # ユーザーをIDで設定

    if @news.save
      @user.update(username: params[:news][:author_name])  # ユーザー名の更新
      @user.update(address_id: params[:news][:prefecture_id])  # ユーザーの都道府県更新※将来的に消す
      redirect_to news_index_path, notice: '記事が作成され、ユーザー名が更新されました'
    else
      render :new
    end
  end

  def show
    # 記事を閲覧したことを記録する
    @news.read_statuses.find_or_create_by(user_id: @user.id).update(read: true)
    @new_news = News.new

    @comment = Comment.new
    @comments = @news.comments.includes(:user)
    @user = current_user # ユーザーがログインしている場合の情報を設定
  end

  def edit
    respond_to do |format|
      format.html { render partial: 'edit_form', locals: { news: @news, categories: @categories, prefectures: @prefectures } }
      format.turbo_stream
    end
  end

  def update
    if @user.update(username: params[:news][:author_name]) && @news.update(news_params)
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

  def news_params
    params.require(:news).permit(:title, :content, :category_id, :prefecture_id, :author_name, images: [], videos: [])
  end

  def set_news
    @news = News.find(params[:id])
  end

  def authorize_user
    unless @user && @news.user_id == @user.id
      redirect_to root_path
    end
  end

  def find_or_create_user
    ip_address = request.remote_ip
    @user = User.find_or_create_by(ip_address: ip_address)
  rescue ActiveRecord::RecordNotUnique
    # 重複が発生した場合は再度検索を行う
    @user = User.find_by(ip_address: ip_address)
  end
  # def find_or_create_user
  #   @user = current_user || User.create(ip_address: request.remote_ip)
  # end
end
