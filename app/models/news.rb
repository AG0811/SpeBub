class News < ApplicationRecord
  has_many_attached :image
  has_many :favorite_news
  has_many :users, through: :favorite_news
end
