Rails.application.config.middleware.use OmniAuth::Builder do
  provider :line, ENV['LINE_CLIENT_ID'], ENV['LINE_CLIENT_SECRET'], scope: 'profile openid'
end
