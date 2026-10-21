class UserEmailsController < ApplicationController
  skip_before_action :require_login
  skip_before_action :require_login_has_shop
  before_action :logged_in_new_shop_path?, only: %i{ new }

  def new
    @user = User.new()
  end

  def create
    @user = User.new(user_email_params)
    if @user.save
      session[:user_id] = @user.id
      # 元々飛びたい場所が店舗登録ではなかったときに、元々のリクエスト先にリダイレクトできるようにする
      redirect_path = session[:request_path]
      session.delete(:request_path)
      redirect_to redirect_path || new_shop_path, success: '登録が完了しました'
    else
      flash.now[:danger] = '失敗しました。もう一度お試しください'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_email_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :age)
  end

  def logged_in_new_shop_path?
    if logged_in?
      redirect_to new_shop_path, success: "店舗登録を行なってください"
    end
  end

end
