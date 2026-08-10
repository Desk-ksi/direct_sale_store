class User < ApplicationRecord
  validates :name, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d{11}\z/ }, uniqueness: true
  has_many :user_shops, dependent: :destroy
  has_many :shops, through: :user_shops
end
