class LoginsController < ApplicationController
  skip_before_action :require_login
  skip_before_action :require_login_has_shop
  before_action :logged_in_new_shop_path?, only: %i{ new }

  # 総当たり攻撃、SMS認証の大量リクエスト対策（コスト対策）でrate_limitを設定
  # limitを数えるキャッシュの保存先が現状では:solid_cache_store（production.rb）になっている
  # これはデータベースにキャッシュ専用のテーブルを作成して、そこにこのアプリのキャッシュを保存する（デフォルト）
  # ただ現状では、本番のデータベースにそのテーブルを作っておらず、rate_limitだけならそこまでキャッシュを使わないため、各々用のキャッシュ保存先を作っている
  # なお、メモリを使う保存先に変えたことで、サーバーを再起動すると、キャッシュに保存していた回数が消える状況である
  RATE_LIMIT_STORE_SMS = ActiveSupport::Cache::MemoryStore.new
  RATE_LIMIT_STORE_VERIFY = ActiveSupport::Cache::MemoryStore.new
  rate_limit to: 5, within: 5.minutes, with: :redirect_to_busy, by: -> { params[:phone_number].to_s.delete("^0-9").sub(/0/,'+81') }, only: :create, name: "create_limit", store: RATE_LIMIT_STORE_SMS
  rate_limit to: 5, within: 5.minutes, with: :redirect_to_busy, by: -> { session[:phone_number] }, only: :verify, name: "verify_limit", store: RATE_LIMIT_STORE_VERIFY

  def new;end

  def create
    account_sid = Rails.application.credentials.twilio.account_sid
    auth_token = Rails.application.credentials.twilio.auth_token
    verify_service_sid = Rails.application.credentials.twilio.verify_service_sid
    phone_number = params[:phone_number].delete("^0-9")
    phone_number_set = phone_number.sub(/0/,'+81')
    @client = Twilio::REST::Client.new(account_sid, auth_token)
    begin
      verification = @client
                    .verify
                    .v2
                    .services(verify_service_sid)
                    .verifications
                    .create(
                      channel: 'sms',
                      to: phone_number_set
                    )
      session[:phone_number] = phone_number_set
      redirect_to action: :confirm
    rescue Twilio::REST::RestError => e
      Rails.logger.error(e.message)
      flash.now[:danger] = "エラーが発生しました。もう一度お試しください"
      render :new
    end
  end

  def confirm
    @phone_number = session[:phone_number]
  end

  def verify
    account_sid = Rails.application.credentials.twilio.account_sid
    auth_token = Rails.application.credentials.twilio.auth_token
    verify_service_sid = Rails.application.credentials.twilio.verify_service_sid
    code = params[:code]
    @client = Twilio::REST::Client.new(account_sid, auth_token)
    begin
      verification_check = @client
                          .verify
                          .v2
                          .services(verify_service_sid)
                          .verification_checks
                          .create(
                            to: session[:phone_number],
                            code: code
                          )
      if verification_check.status == "approved"
        user = User.find_by(phone_number: session[:phone_number])
        if user.present?
          # セッション固定攻撃対策でsessionをリセットする前に、後で使うsessionを取っておく
          redirect_path = session[:request_path]
          # セッション固定攻撃対策でsessionを更新する前に一度リセットする
          reset_session
          session[:user_id] = user.id
          redirect_to redirect_path || root_path, success: 'あなたの確認ができました'
        else
          redirect_to controller: :users, action: :new, success: 'あなたの確認ができました。あなたを登録してください'
        end
      else
        @phone_number = session[:phone_number]
        flash.now[:danger] = '失敗しました。もう一度お試しください'
        render :confirm
      end
    rescue Twilio::REST::RestError => e
      Rails.logger.error(e.message)
      @phone_number = session[:phone_number]
      flash.now[:danger] = "エラーが発生しました。もう一度お試しください"
      render :confirm
    end
  end

  def destroy
    logout
    redirect_to root_path, success: 'ログアウトしました', status: :see_other
  end

  private

  def logged_in_new_shop_path?
    if logged_in?
      redirect_to new_shop_path, success: "店舗登録を行なってください"
    end
  end

  def redirect_to_busy 
    redirect_to  root_path, danger: "試せる回数を超えました。時間が経ってから再度試してください" 
  end 
end
