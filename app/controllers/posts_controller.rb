class PostsController < ApplicationController
  def new
    @post = Post.new
    # 投稿フォームには別モデルのpost_imagesも呼び出さないといけないから、下のコードが必要
    @post.post_images.build
  end
  def create
    shop = current_user_has_shop.shop
    @post = shop.posts.new(post_params)
    if @post.save
      redirect_to root_path, success: "今日の出荷状況を投稿しました"
    else
      flash.now[:danger] = "投稿に失敗しました。再度投稿してください"
      render :new,status: :unprocessable_entity
    end
  end

  private

  def post_params
    # post_images_attributes 関連づけられたテーブルからのパラメーターはこのようにはいり、その中でどのカラムを使うかを指定。[]の中に、post_imagesテーブルのどのカラムを使うかを指定する
    params.require(:post).permit(:merchandise, :schedule, :top_merchandise, post_images_attributes: [:post_image])
  end
end

