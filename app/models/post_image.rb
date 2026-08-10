class PostImage < ApplicationRecord
  mount_uploader :post_image, PostImageUploader
  validates :post_image, presence: true
  belongs_to :post
end
