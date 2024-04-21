class VotesController < ApplicationController
  before_action :authenticate_user!  # ユーザー認証が必要な場合
  
  def vote
    # idで映画を検索
    @movie = Movie.find_by(id: params[:id])
  
    # ユーザーの全体の投票回数を確認
    user_total_votes = Vote.where(user: current_user).count
  
    # ユーザーが特定の映画に投票しているか確認
    user_movie_votes = Vote.where(user: current_user, movie: @movie).count
  
    if user_total_votes >= 3
      flash[:alert] = "You can only vote 3 times."
    elsif user_movie_votes > 0
      flash[:alert] = "You have already voted for this movie."
    else
      # 投票を記録
      Vote.create(user: current_user, movie: @movie)
  
      flash[:notice] = "You have voted for #{@movie.title} (#{user_total_votes + 1}/3)"
    end
  
    # 映画のページにリダイレクト
    redirect_to movie_path(@movie.api_id)
  end
end
