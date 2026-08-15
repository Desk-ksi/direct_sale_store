class ShopsController < ApplicationController
  skip_before_action :require_login_has_shop
  def new
    @shop = Shop.new
  end
  def create
    @shop = Shop.new(shop_params)
    user = User.find_by(id: session[:user_id])
    if @shop.save
      UserShop.create!(user: user, shop: @shop)
      redirect_to complete_shops_path, success: "あなたの店舗の登録が完了しました"
    else
      flash.now[:danger] = "店舗の登録に失敗しました。再度店舗登録を行なってください"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def shop_params
    params.require(:shop).permit(:shop_image, :name, :latitude, :longitude, :kodawari, :price, :season, :timing, :business_hours)
  end
end
