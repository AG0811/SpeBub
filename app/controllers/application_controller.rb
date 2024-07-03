# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  DEFAULT_PREFECTURE_ID = 1
  DEFAULT_IP = '42.150.195.9'

  helper_method :current_user
  before_action :basic_auth

  private

  def current_user
    @current_user ||= find_or_create_user_by_ip
  end

  def find_or_create_user_by_ip
    user = User.find_or_create_by(ip_address: request.remote_ip)

    location = GeoLocation.lookup(request.remote_ip)
    prefecture = ActiveHash::Prefecture.find_by(name: location[:state])

    unless user.address_id
      if prefecture
        user.update(address_id: prefecture.id)
      else
        Rails.logger.warn "Prefecture not found for state: #{location[:state]}"
      end
    end

    user
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == 'admin' && password == '2222'
    end
  end
end
