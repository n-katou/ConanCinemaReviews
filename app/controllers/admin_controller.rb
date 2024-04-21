class AdminController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @users = User.order(:id)  # ユーザーをIDで昇順に並べる
  end

  def reset_vote_count
    user = User.find_by(id: params[:user_id])  # ユーザーIDで検索
    if user
      # ユーザーの投票を全て削除
      Vote.where(user_id: user.id).destroy_all
  
      # 投票数をリセット
      user.update(vote_count: 0)
  
      flash[:notice] = "ユーザー#{user.name}の投票数をリセットしました。"
    else
      flash[:alert] = "ユーザーが見つかりません。"
    end
  
    # 管理画面にリダイレクト
    redirect_to admin_path
  end
end
