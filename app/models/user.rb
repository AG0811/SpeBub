class User < ApplicationRecord
  has_many :favorites
  has_many :favorite_news, through: :favorites, source: :news
end
