# app/controllers/news_controller.rb

class NewsController < ApplicationController
  before_action :load_active_hash, only: [:index, :new, :create, :show, :edit, :search]
  before_action :find_or_create_user
  before_action :set_news, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]
  before_action :move_to_index, except: [:index, :show, :search]

  # OpenWeatherMapのAPIキーを設定。
  OPENWEATHERMAP_API_KEY = ENV['OPENWEATHERMAP_API_KEY']

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

    #東京の天気ダミー
    weather_service = WeatherService.new(OPENWEATHERMAP_API_KEY) # 自分のAPIキーに置き換えてください
    weather_data = weather_service.fetch_weather_forecast('Tokyo,JP')

    if weather_data[:success?]
      @weather_forecast = parse_weather_forecast(weather_data[:data])
    else
      flash.now[:alert] = '天気情報の取得に失敗しました'
    end
  end

  def new
    @news = News.new
  end

  def create
    @news = News.new(news_params)
    @news.user_id = @user.id

    ip_address = request.remote_ip == '::1' ? DEFAULT_IP : request.remote_ip
    location = GeoLocation.lookup(ip_address)
    current_prefecture_id = prefecture_name_to_id(location[:state])

    if current_prefecture_id
      @user.update(address_id: current_prefecture_id)
      @news.prefecture_id = current_prefecture_id
    else
      Rails.logger.warn "Prefecture not found for state: #{location[:state]}"
      @news.prefecture_id = DEFAULT_PREFECTURE_ID
    end

    if @news.save
      @user.update(username: params[:news][:author_name])
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
    redirect_to root_path unless @user && @news.user_id == @user.id
  end

  def move_to_index
    redirect_to root_path, alert: 'ユーザーが見つかりませんでした。再度お試しください。' unless @user.present?
  end

  def find_or_create_user
    ip_address = request.remote_ip
    ip_address = DEFAULT_IP if ip_address == '::1'

    @user = User.find_or_create_by(ip_address: ip_address)

    location = GeoLocation.lookup(ip_address)
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
    redirect_to root_path, alert: 'ユーザーの作成に失敗しました。再度お試しください。'
  end
  def prefecture_name_to_id(prefecture_name)
    ActiveHash::Prefecture.find_by(romanized_name: prefecture_name)&.id
  end

  def parse_weather_forecast(data)
    today = Date.today
    tomorrow = today + 1
    day_after_tomorrow = today + 2

    weather_forecast = {
      today: find_weather_for_date(data, today),
      tomorrow: find_weather_for_date(data, tomorrow),
      day_after_tomorrow: find_weather_for_date(data, day_after_tomorrow)
    }

    weather_forecast
  end
  def find_weather_for_date(data, date)
    weather_data = data.find { |entry| Date.parse(entry['dt_txt']).to_date == date }
    format_weather_data(weather_data) if weather_data
  end
  def format_weather_data(data)
    {
      weather: data['weather'][0]['description'],
      temperature: data['main']['temp'],
      humidity: data['main']['humidity']
    }
  end
end
