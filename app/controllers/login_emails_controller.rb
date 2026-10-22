class LoginEmailsController < ApplicationController
  skip_before_action :require_login
  skip_before_action :require_login_has_shop
  before_action :logged_in_new_shop_path?, only: %i{ new }

  # 総当たり攻撃対策でrate_limitを設定
  # limitを数えるキャッシュの保存先が現状では:solid_cache_store（production.rb）になっている
  # これはデータベースにキャッシュ専用のテーブルを作成して、そこにこのアプリのキャッシュを保存する（デフォルト）
  # ただ現状では、本番のデータベースにそのテーブルを作っておらず、rate_limitだけならそこまでキャッシュを使わないため、各々用のキャッシュ保存先を作っている
  # なお、メモリを使う保存先に変えたことで、サーバーを再起動すると、キャッシュに保存していた回数が消える状況である
  RATE_LIMIT_STORE_EMAIL = ActiveSupport::Cache::MemoryStore.new
  rate_limit to: 5, within: 5.minutes, with: :redirect_to_busy, only: :create, store: RATE_LIMIT_STORE_EMAIL

  def new;end

  def create
    @user = User.find_by(email: params[:email])
    # パラメーターできたパスワードが平文化されたpassword_digestとあっているかをauthenticateで確認
    # 間違ったときにエラーが発生した内容にボッチ演算子（.&）
    if @user&.authenticate(params[:password])
      # 元々飛びたい場所が店舗登録ではなかったときに、元々のリクエスト先にリダイレクトできるようにする
      redirect_path = session[:request_path]
      # セッション固定攻撃対策でsessionを更新する前に一度リセットする
      reset_session
      session[:user_id] = @user.id
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

  def redirect_to_busy 
    redirect_to root_path, danger: "試せる回数を超えました。時間が経ってから再度試してください" 
  end 

end
