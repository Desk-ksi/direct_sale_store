class LoginsController < ApplicationController
  skip_before_action :require_login
  skip_before_action :require_login_has_shop
  before_action :logged_in_new_shop_path?
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
          session[:user_id] = user.id
          redirect_path = session[:request_path]
          session.delete(:request_path)
          redirect__to redirect_path || root_path, success: 'ログインが完了しました'
        else
          redirect_to controller: :users, action: :new, success: '認証ができました。ユーザー登録をしてください'
        end
      else
        @phone_number = session[:phone_number]
        flash.now[:danger] = '認証に失敗しました。もう一度お試しください'
        render :confirm
      end
    rescue Twilio::REST::RestError => e
      Rails.logger.error(e.message)
      @phone_number = session[:phone_number]
      flash.now[:danger] = "エラーが発生しました。もう一度お試しください"
      render :confirm
    end
  end

  private

  def logged_in_new_shop_path?
    if logged_in?
      redirect_to new_shop_path, success: "店舗登録を行なってください"
    end
  end
end
