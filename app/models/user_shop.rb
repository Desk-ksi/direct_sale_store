class UserShop < ApplicationRecord
  validates :user_id, uniqueness: { scope: :shop_id}
  belongs_to :user
  belongs_to :shop
end
w