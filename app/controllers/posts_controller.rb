class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[ show ]
  skip_before_action :require_login_has_shop, only: %i[ show ]
  def new
    @shop = Shop.find(params[:shop_id])
    @post = @shop.posts.new
    # 投稿フォームには別モデルのpost_imagesも呼び出さないといけないから、下のコードが必要
    @post.post_images.build
  end
  def create
    shop = Shop.find(params[:shop_id])
    @post = shop.posts.new(post_params)
    if @post.save
      redirect_to root_path, success: "今日の出荷状況を投稿しました"
    else
      flash.now[:danger] = "投稿に失敗しました。再度投稿してください"
      render :new,status: :unprocessable_entity
    end
  end
  def my_shops
    @user = current_user
    @shops = @user.shops.page(params[:page])
  end
  def index
    @shop = current_user.shops.find(params[:shop_id])
    @posts = @shop.posts.page(params[:page])
  end
  def show
    @post = Post.find(params[:id])
  end
  def edit
    shop = current_user.shops.find(params[:shop_id])
    @post = shop.posts.find(params[:id])
  end
  def update
    shop = current_user.shops.find(params[:shop_id])
    @post = shop.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to shop_posts_path(shop), success: '投稿の変更が完了しました'
    else
      flash.now[:danger] = '投稿の変更に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    shop = current_user.shops.find(params[:shop_id])
    @post = shop.posts.find(params[:id])
    if @post.destroy
      redirect_to shop_posts_path(shop), success: '投稿の削除が完了しました'
    else
      @posts = shop.posts.page(params[:page])
      flash.now[:danger] = '投稿の削除に失敗しました'
      render :index, status: :see_other
    end
  end

  private

  def post_params
    # post_images_attributes 関連づけられたテーブルからのパラメーターはこのようにはいり、その中でどのカラムを使うかを指定。[]の中に、post_imagesテーブルのどのカラムを使うかを指定する
    params.require(:post).permit(:comment,:merchandise, :schedule, :top_merchandise, post_images_attributes: [:id, :post_image])
  end
end

