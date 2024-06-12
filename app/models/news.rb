class News < ApplicationRecord
  has_many_attached :images # 例: 複数の画像を添付する場合
  # has_one_attached :image # 例: 1つの画像を添付する場合
  has_many :favorite_news
  has_many :users, through: :favorite_news
end
