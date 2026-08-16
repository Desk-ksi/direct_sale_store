class StaticPagesController < ApplicationController
  skip_before_action :require_login
  skip_before_action :require_login_has_shop
  def top
    # 降順（新しいものが上で最初の10件取得）
    # viewで店舗情報や投稿写真を取得するたびにクエリを発生させないため（N＋1問題の解決）にincledesで一括取得
    @posts = Post.includes(:shop, :post_images).order(created_at: :desc).first(10)
  end
  def how_to;end
  def user_how_to;end
  def shop_how_to;end
  def post_how_to;end
  def promote_how_to;end
end
