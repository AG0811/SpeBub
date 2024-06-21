class User < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :favorite_news, through: :favorites, source: :news, dependent: :destroy

  has_many :read_statuses, dependent: :destroy
end
