class News < ApplicationRecord
  # dependent: :destroyをつけることで、親のレコードが削除された場合に、関連付いている子のレコードも一緒に削除される
  has_many_attached :images, dependent: :destroy
  has_many_attached :videos, dependent: :destroy
  has_many :favorite_news, dependent: :destroy
  has_many :users, through: :favorite_news, dependent: :destroy
end
