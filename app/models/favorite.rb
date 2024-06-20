class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :news

  def favorited_by?(user)
    self.user_id == user.id
  end
end