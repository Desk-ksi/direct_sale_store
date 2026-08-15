class Post < ApplicationRecord
  validates :merchandise, length: { maximum: 255 }
  validates :top_merchandise, length: { maximum: 255 }
  validates :comment, length: { maximum: 500 }
  validates :schedule, length: { maximum: 255 }
  # validates_associated 紐づいているpost_imagesの中身が正しい（壊れていない）かチェックする
  validates_associated :post_images
  belongs_to :shop
  has_many :post_images, dependent: :destroy
  # accepts_nested_attributes_for has_manyなどでそのモデルの"子モデル"になっているモデルのカラムを"親モデルで"指定できるようにするために使う
  accepts_nested_attributes_for :post_images
  has_many :user_post_likes, dependent: :destroy
  # 中間テーブルを介して、postをお気に入りにしたuserを参照するときのメソッドを定義。sourceは何を参照するかを明示
  has_many :favorite_users, through: :user_post_likes, source: :user
end
