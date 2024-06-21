class Comment < ApplicationRecord
  belongs_to :news  # newsテーブルとのアソシエーション
  belongs_to :user  # usersテーブルとのアソシエーション
end
