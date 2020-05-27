class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { self.order(created_at: :desc) }#投稿された最新順に
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
end
