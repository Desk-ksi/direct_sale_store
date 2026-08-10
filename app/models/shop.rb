class Shop < ApplicationRecord
  mount_uploader :shop_image, ShopImageUploader
end
