class Post < ApplicationRecord
  validates :merchandise, length: { maximum: 255 }
  validates :top_merchandise, length: { maximum: 255 }
  validates :comment, length: { maximum: 500 }
  validates :schedule, length: { maximum: 255 }
  belongs_to :shop
  has_many :post_images
end
