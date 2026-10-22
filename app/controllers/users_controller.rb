class UsersController < ApplicationController
  skip_before_action :require_login
  skip_before_action :require_login_has_shop
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    @user.phone_number = session[:phone_number]
    if @user.save
      redirect_path = session[:request_path]
      # セッション固定攻撃対策でsessionを更新する前に、一度sessionをリセットする
      # ついでに消す必要のあったsession[:phone_number]も消すことができる
      reset_session
      session[:user_id] = @user.id
      redirect_to redirect_path || new_shop_path, success: "あなたを登録完了しました。あなたの店舗を登録してください"
    else
      flash.now[:danger] = "登録に失敗しました。再度登録してください"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :age, :email)
  end
end
