class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    @user.phone_number = session[:phone_number]
    if @user.save
      session.delete(:phone_number)
      session[:user_id] = @user.id
      redirect_to new_shop_path, success: "あなたを登録完了しました。あなたの店舗を登録してください"
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
