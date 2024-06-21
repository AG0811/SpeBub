class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :basic_auth # Basic認証

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def basic_auth # Basic認証
    authenticate_or_request_with_http_basic do |username, password|
      username == 'admin' && password == '2222'
    end
  end
end
