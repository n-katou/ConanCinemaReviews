class AdminController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @users = User.all  # 全ユーザーを取得
  end

  def reset_vote_count
    user = User.find_by(id: params[:user_id])  # ユーザーIDで検索
    if user
      user.update(vote_count: 0)  # 投票数をリセット
      flash[:notice] = "ユーザー#{user.name}の投票数をリセットしました。"
    else
      flash[:alert] = "ユーザーが見つかりません。"
    end
    redirect_to admin_path
  end
end
