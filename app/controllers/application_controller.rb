class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_user

  protected

  def configure_permitted_parameters
    # /users/sign_up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end

  def authenticate_admin!
    unless current_user && current_user.email == ENV['ADMIN_EMAIL']
      flash[:alert] = "アクセスが許可されていません。"
      redirect_to root_path
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_user_info
    current_user ? current_user.email : 'Not logged in'
  end
end
