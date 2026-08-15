class PostsController < ApplicationController
  def new
    @post = Post.new
  end
  def create
    shop = current_user_has_shop.shop
    @post = shop.posts.new(post_params)
    if @post.save
      redirect_to "#", success: "今日の出荷状況を投稿しました"
    else
      flash.now[:danger] = "投稿に失敗しました。再度投稿してください"
      render :new,status: :unprocessable_entity
    end
  end

  private

  def post_params
    # post_images_attributes 関連づけられたテーブルからのパラメーターはこのようにはいり、その中でどのカラムを使うかを指定。画像は複数枚あるから、post_imageを[]に入れる
    params.require(:post).permit(post_images_attributes: [:post_image], :merchandise, :schedule, :top_merchandise)
  end
end

