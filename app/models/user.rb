class User < ApplicationRecord
  has_many :favorites
  has_many :favorite_news, through: :favorites, source: :news

  # 以下の関連付けが不要なため削除する
  # has_many :news, through: :favorite
end
