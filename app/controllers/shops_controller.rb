class ShopsController < ApplicationController
  skip_before_action :require_login, only: %i{ index index_distance show }
  skip_before_action :require_login_has_shop, only: %i{ index index_distance show }
  def index
    # kaminariでページネーションを実装。20件ごとの設定
    @shops = Shop.includes(:posts).page(params[:page])
  end
  # 距離計測メソッド　参考：https://qiita.com/Fu990628/items/4b673a6fea74570dcfd8
  def index_distance
    x1 = params[:current_latitude].to_f * Math::PI / 180
    y1 = params[:current_longitude].to_f * Math::PI / 180

    distance = []
    Shop.all.each do |t|
      x2 = t.latitude * Math::PI / 180
      y2 = t.longitude * Math::PI / 180

      diff_y = (y1 - y2).abs
      
      calc1 = Math.cos(x2) * Math.sin(diff_y)
      calc2 = Math.cos(x1) * Math.sin(x2) - Math.sin(x1) * Math.cos(x2) * Math.cos(diff_y)
      
      numerator = Math.sqrt(calc1 ** 2 + calc2 ** 2)
      denominator = Math.sin(x1) * Math.sin(x2) + Math.cos(x1) * Math.cos(x2) * Math.cos(diff_y)
      degree = Math.atan2(numerator, denominator)

      a = 6378.137
      result = degree * a

      distance.push( [result, t] )
    end
    # 配列で取得した距離と店舗の配列を距離順に並び替えて、インスタンス変数にして、viewで使用する
    # 現状配列には、距離と店舗オブジェクトがセットになっている
    # sortで並び変えはできるが、距離と店舗どちらで並び替えるかを定義しないといけない
    # |x| x[0] は配列の最初の値を元にsortすることを示している
    distance = distance.sort_by{|x| x[0]}
    # 配列にkaminariでページネーションをするときは以下の形になる
    @distance = Kaminari.paginate_array(distance).page(params[:page])
  end

  def new
    @shop = Shop.new
  end
  def create
    @shop = Shop.new(shop_params)
    user = User.find_by(id: session[:user_id])
    if @shop.save
      UserShop.create!(user: user, shop: @shop)
      redirect_path = session[:request_path]
      session.delete(:request_path)
      redirect_to redirect_path || complete_shops_path, success: "あなたの店舗の登録が完了しました"
    else
      flash.now[:danger] = "店舗の登録に失敗しました。再度店舗登録を行なってください"
      render :new, status: :unprocessable_entity
    end
  end
  def complete;end
  def show
    @shop = Shop.find_by(id: params[:id])
    @posts = @shop.posts
  end
  def my_shops
    @user = current_user
    @shops = @user.shops.page(params[:page])
  end
  def edit
    @shop = Shop.find(params[:id])
  end
  def update
    @shop = Shop.find(params[:id])
    if @shop.update(shop_params)
      redirect_to my_shops_shops_path, success: '更新に成功しました'
    else
      flash.now[:danger] = '更新できませんでした'
      render :edit, status: :unprocessable_entity
    end
  end

      private

  def shop_params
    params.require(:shop).permit(:shop_image, :name, :latitude, :longitude, :kodawari, :price, :season, :timing, :business_hours)
  end
end
