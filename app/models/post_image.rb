class PostImage < ApplicationRecord
  mount_uploader :post_image, PostImageUploader
end
