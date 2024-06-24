# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :basic_auth # Basic認証

  private

  def current_user
    @current_user ||= find_or_create_user_by_ip
  end

  def find_or_create_user_by_ip
    user = User.find_by(ip_address: request.remote_ip)

    unless user
      user = User.create(ip_address: request.remote_ip)
      # ここで他の必要な初期化処理を行う場合があります
    end

    user
  end

  def basic_auth # Basic認証
    authenticate_or_request_with_http_basic do |username, password|
      username == 'admin' && password == '2222'
    end
  end
end
