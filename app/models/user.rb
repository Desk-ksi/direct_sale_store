class User < ApplicationRecord
  validates :name, presence: true
  validates :phone_number, presence: true, format: { with: /\A\+\d{12}\z/ }, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true, allow_blank: true
  has_many :user_shops, dependent: :destroy
  has_many :shops, through: :user_shops
  has_many :user_shop_likes, dependent: :destroy
  # 中間テーブルを介して、userがお気に入りにしたshopを参照するときのメソッドを定義。sourceは何を参照するかを明示
  has_many :favorite_shops, through: :user_shop_likes, source: :shop
  has_many :user_post_likes, dependent: :destroy
  # 中間テーブルを介して、userがお気に入りにしたpostを参照するときのメソッドを定義。sourceは何を参照するかを明示
  has_many :favorite_posts, through: :user_post_likes, source: :post
end
