class GoogleOauthsController < ApplicationController

  def oauth
    client_id = ENV['GOOGLE_CLIENT_ID']
    redirect_uri = "https://conancinemareviews.onrender.com/oauth/callback?provider=google"
    # 開発環境の場合、以下を使用
    # redirect_uri = "http://localhost:3000/oauth/callback?provider=google"
    scope = "email profile"
    state = "SOME_STATE_VALUE"

    oauth_url = "https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=#{client_id}&redirect_uri=#{CGI.escape(redirect_uri)}&scope=#{CGI.escape(scope)}&state=#{state}&access_type=offline&prompt=consent"
    redirect_to oauth_url, allow_other_host: true  # 他のホストへのリダイレクトを許可
  end

  def callback
    service = GoogleOauthService.new(params[:code])
    user = service.authenticate  # `@user`から`user`に変更

    if user
      reset_session  # セッションをリセット
      sign_in(user)  # ユーザーをDeviseでログイン
      redirect_to root_path, notice: 'ログインに成功しました！'  # 成功時のリダイレクト
    else
      Rails.logger.error("ログイン処理中にエラーが発生しました。")  # エラー時のログ出力
      redirect_to new_user_registration_path, alert: 'ログインに失敗しました。'  # 失敗時のリダイレクト
    end
  end
end
