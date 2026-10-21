class LoginEmailsController < ApplicationController
  skip_before_action :require_login
  skip_before_action :require_login_has_shop
  before_action :logged_in_new_shop_path?, only: %i{ new }

  def new;end

  def create
    @user = User.find_by(email: params[:email])
    # パラメーターできたパスワードが平文化されたpassword_degistとあっているかをauthenticateで確認
    # 間違ったときにエラーが発生した内容にボッチ演算子（.&）
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_path = session[:request_path]
      session.delete(:request_path)
      redirect_to redirect_path || root_path, success: 'あなたの確認ができました'
    else
      flash.now[:danger] = '失敗しました。もう一度お試しください'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def logged_in_new_shop_path?
    if logged_in?
      redirect_to new_shop_path, success: "店舗登録を行なってください"
    end
  end

end
