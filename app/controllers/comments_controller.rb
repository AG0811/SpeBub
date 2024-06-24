class CommentsController < ApplicationController
  before_action :find_or_create_user

  def create
    comment = Comment.new(comment_params)
    if comment.save
      redirect_to "/news/#{comment.news.id}"  # コメントと結びつくニュースの詳細画面に遷移する
    else
      redirect_to "/news/#{comment.news.id}", alert: "コメントの作成に失敗しました。"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(user_id: @user.id, news_id: params[:news_id])
  end

  def find_or_create_user
    ip_address = request.remote_ip
    @user = User.find_or_create_by!(ip_address: ip_address)
  rescue ActiveRecord::RecordNotUnique
    @user = User.find_by(ip_address: ip_address)
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "User creation failed: #{e.message}"
    redirect_to root_path, alert: "ユーザーの作成に失敗しました。再度お試しください。"
  end
end
