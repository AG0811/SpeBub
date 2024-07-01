# app/controllers/news_controller.rb

class NewsController < ApplicationController
  before_action :load_active_hash, only: [:index, :new, :create, :show, :edit, :search]
  before_action :find_or_create_user
  before_action :set_news, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]
  before_action :move_to_index, except: [:index, :show, :search]

  def index
    @news = News.order(created_at: :desc)
    @new_news = News.new
    @favorited_news_ids = current_user.favorite_news.pluck(:id) if current_user

    if params[:keyword].present? || params[:category_id].present?
      keyword = "%#{params[:keyword]}%"
      category_id = params[:category_id]

      @news = @news.where('content LIKE ? OR title LIKE ?', keyword, keyword) if params[:keyword].present?
      @news = @news.where(category_id: category_id) if params[:category_id].present?
    end
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
    # @user = current_user # ユーザーがログインしている場合の情報を設定
  end

  def search
    @news = News.search(params[:keyword])
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
    @user = User.find_or_create_by!(ip_address: ip_address)

    # GeoLocationモデルを使って位置情報を取得
    location = GeoLocation.lookup(ip_address)
    Rails.logger.debug "Location lookup result: #{location}"
    prefecture = ActiveHash::Prefecture.find_by(name: location[:state])
  
    if prefecture
      @user.update(address_id: prefecture.id)
    else
      Rails.logger.warn "Prefecture not found for state: #{location[:state]}"
      @user.update(address_id: nil)
    end
  
    rescue ActiveRecord::RecordNotUnique
      @user = User.find_by(ip_address: ip_address)
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "User creation failed: #{e.message}"
      redirect_to root_path, alert: "ユーザーの作成に失敗しました。再度お試しください。"
  end

  def move_to_index
    unless @user.present?
      redirect_to root_path, alert: "ユーザーが見つかりませんでした。再度お試しください。"
    end
  end
end

