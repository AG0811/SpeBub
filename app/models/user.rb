class User < ApplicationRecord
  has_many :favorite_news
  has_many :news, through: :favorite_news
end
