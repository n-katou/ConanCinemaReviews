class GoogleOauthsController < ApplicationController

  def oauth
    client_id = ENV['GOOGLE_CLIENT_ID']
    redirect_uri = "https://conancinemareviews.onrender.com/oauth/callback?provider=google"
    # redirect_uri = "http://localhost:3000/oauth/callback?provider=google"
    scope = "email profile"
    state = "SOME_STATE_VALUE"

    oauth_url = "https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=#{client_id}&redirect_uri=#{CGI.escape(redirect_uri)}&scope=#{CGI.escape(scope)}&state=#{state}&access_type=offline&prompt=consent"
    redirect_to oauth_url, allow_other_host: true
  end

  def callback
    service = GoogleOauthService.new(params[:code])
    @user = service.authenticate

    if @user
      reset_session
      auto_login(@user)
      redirect_to root_path, notice: t('auth.login_success')
    else
      Rails.logger.error { "ログイン処理中にエラーが発生しました。" }
      redirect_to login_path, alert: t('auth.login_failed')
    end
  end

  private
end