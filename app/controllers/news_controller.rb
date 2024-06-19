class NewsController < ApplicationController
  before_action :load_active_hash, only: [:index, :new, :create, :show, :edit]
  before_action :find_or_create_user
  before_action :set_news, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]  # 追加

  def index
    @news = News.order(created_at: :desc)
    @new_news = News.new
  end

  def new
    @news = News.new
  end

  def create
    @news = News.new(news_params)
    @news.user_id = @user.id
    @user.username = params[:news][:author_name] # ユーザー名を更新
    if @news.save && @user.save # ニュースとユーザーの両方を保存
      redirect_to news_index_path, notice: '記事が作成され、ユーザー名が更新されました'
    else
      render :new
    end
  end

  def show
    @new_news = News.new
  end

  def edit
  #  @news = News.find(params[:id])
  #  find_or_create_user
    respond_to do |format|
      format.html { render partial: 'edit_form', locals: { news: @news, categories: @categories, prefectures: @prefectures } }
      format.turbo_stream
  #    format.html { render partial: 'news/edit_form', locals: { news: @news } }
  #    format.js
    end
  end

  def update
    # ユーザー名の更新
    @user.update(username: params[:news][:author_name])
    # ニュースの更新
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

  def news_params
    params.require(:news).permit(:title, :content, :prefecture_id, :category_id, :author_name, images: [], videos: [])
  end

  def set_news
    @news = News.find(params[:id])
    logger.info "News found: #{@news.inspect}"
  end

  def authorize_user
    unless @user && @news.user_id == @user.id
      redirect_to root_path
    end
    logger.info "Authorize user check: @user = #{@user.inspect}, @news.user_id = #{@news.user_id}"
  end

  def find_or_create_user
    @user = User.find_or_create_by(ip_address: request.remote_ip)
    logger.info "User found or created: #{@user.inspect}"
  end
end
