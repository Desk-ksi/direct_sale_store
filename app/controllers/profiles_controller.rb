class ProfilesController < ApplicationController
  skip_before_action :require_login_has_shop

  def show
    @user = current_user
  end
  
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path(@user), success: 'プロフィールの変更が完了しました'
    else
      flash.now[:danger] = 'プロフィールの変更に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = current_user
    if @user.destroy
      logout
      redirect_to root_path, success: 'アカウントの削除が完了しました'
    else
      flash.now[:danger] = 'アカウントの削除に失敗しました'
      render :edit, status: :see_other
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :age, :email)
  end
end
