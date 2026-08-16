class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  add_flash_types :success, :danger
  before_action :require_login
  before_action :require_login_has_shop
  def logged_in?
    !!current_user
  end
  def logged_in_has_shop?
    !!current_user_has_shop
  end
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  def current_user_has_shop
    @current_user_has_shop ||= UserShop.find_by(user_id: session[:user_id]) if logged_in?
  end

  private

  def require_login
    redirect_to new_login_path, danger: "ログイン後に操作できます" unless logged_in?
  end
  def require_login_has_shop
    redirect_to new_shop_path, danger: "店舗登録後に操作できます" unless logged_in_has_shop?
  end
end
