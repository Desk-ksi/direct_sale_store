class Shop < ApplicationRecord
  mount_uploader :shop_image, ShopImageUploader
  validates :name, presence: true, length: { maximum: 255 }
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :shop_image, presence: true
  validates :kodawari, length: { maximum: 500 }
  validates :price, length: { maximum: 255 }
  validates :season, length: { maximum: 255 }
  validates :business_hours, length: { maximum: 255 }
  validates :timing, length: { maximum: 255 }
  validates :prefecture, presence: true
  has_many :posts, dependent: :destroy
  has_many :user_shops, dependent: :destroy
  has_many :users, through: :user_shops
  has_many :user_shop_likes, dependent: :destroy
  # 中間テーブルを介して、shopをお気に入りにしたuserを参照するときのメソッドを定義。sourceは何を参照するかを明示
  has_many :favorite_users, through: :user_shop_likes, source: :user
end
