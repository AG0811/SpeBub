class NewsController < ApplicationController
  before_action :load_active_hash, only: [:index, :new, :create, :show, :edit, :search]
  before_action :find_or_create_user
  before_action :set_news, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]
  before_action :move_to_index, except: [:index, :show, :search]

  DEFAULT_IP = '8.8.8.8' # 適切なデフォルトのIPに変更

  # 初期化時にDEFAULT_PREFECTURE_IDを設定
  location = GeoLocation.lookup(DEFAULT_IP)
  default_prefecture_name = location[:state]
  default_prefecture_id = ActiveHash::Prefecture.find_by(name: default_prefecture_name)&.id
  DEFAULT_PREFECTURE_ID = default_prefecture_id || 1

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

    # ローカルIPの場合、ダミーIPを使用
    ip_address = request.remote_ip == '::1' ? DEFAULT_IP : request.remote_ip
    location = GeoLocation.lookup(ip_address)
    current_prefecture_id = prefecture_name_to_id(location[:state])

    if current_prefecture_id
      @user.update(address_id: current_prefecture_id)
      @news.prefecture_id = current_prefecture_id # ここでprefecture_idをセット
    else
      Rails.logger.warn "Prefecture not found for state: #{location[:state]}"
      @news.prefecture_id = DEFAULT_PREFECTURE_ID # デフォルト値を設定
    end

    if @news.save
      @user.update(username: params[:news][:author_name])  # ユーザー名の更新
      redirect_to news_index_path, notice: '記事が作成され、ユーザー名が更新されました'
    else
      render :new
    end
  end

  def show
    @news.read_statuses.find_or_create_by(user_id: @user.id).update(read: true)
    @new_news = News.new
    @comment = Comment.new
    @comments = @news.comments.includes(:user)
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
    ip_address = DEFAULT_IP if ip_address == '::1' # ローカル開発時にダミーIPを使用

    @user = User.find_or_create_by!(ip_address: ip_address)

    # GeoLocationモデルを使って位置情報を取得
    location = GeoLocation.lookup(ip_address)
    Rails.logger.debug "Location lookup result: #{location}"
    prefecture_id = prefecture_name_to_id(location[:state])

    if prefecture_id
      @user.update(address_id: prefecture_id)
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

  def prefecture_name_to_id(prefecture_name)
    prefecture_mappings = {
      "Hokkaido" => 1,
      "Aomori" => 2,
      "Iwate" => 3,
      "Miyagi" => 4,
      "Akita" => 5,
      "Yamagata" => 6,
      "Fukushima" => 7,
      "Ibaraki" => 8,
      "Tochigi" => 9,
      "Gunma" => 10,
      "Saitama" => 11,
      "Chiba" => 12,
      "Tokyo" => 13,
      "Kanagawa" => 14,
      "Niigata" => 15,
      "Toyama" => 16,
      "Ishikawa" => 17,
      "Fukui" => 18,
      "Yamanashi" => 19,
      "Nagano" => 20,
      "Gifu" => 21,
      "Shizuoka" => 22,
      "Aichi" => 23,
      "Mie" => 24,
      "Shiga" => 25,
      "Kyoto" => 26,
      "Osaka" => 27,
      "Hyogo" => 28,
      "Nara" => 29,
      "Wakayama" => 30,
      "Tottori" => 31,
      "Shimane" => 32,
      "Okayama" => 33,
      "Hiroshima" => 34,
      "Yamaguchi" => 35,
      "Tokushima" => 36,
      "Kagawa" => 37,
      "Ehime" => 38,
      "Kochi" => 39,
      "Fukuoka" => 40,
      "Saga" => 41,
      "Nagasaki" => 42,
      "Kumamoto" => 43,
      "Oita" => 44,
      "Miyazaki" => 45,
      "Kagoshima" => 46,
      "Okinawa" => 47
    }
    prefecture_mappings[prefecture_name]
  end
end
