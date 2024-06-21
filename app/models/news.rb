class News < ApplicationRecord
  # dependent: :destroyをつけることで、親のレコードが削除された場合に、関連付いている子のレコードも一緒に削除される
  has_many_attached :images, dependent: :destroy
  has_many_attached :videos, dependent: :destroy
  has_many :favorites, dependent: :destroy  # お気に入り関連の関連付け
  has_many :favorited_users, through: :favorites, source: :user, dependent: :destroy  # お気に入りを付けたユーザーの関連付け

  belongs_to :user
  def favorite_by?(user)
    favorites.exists?(user_id: user.id)
  end

  has_many :read_statuses, dependent: :destroy
  def read_by_user?(user)
    read_statuses.exists?(user_id: user.id, read: true)
  end
end
