class VotesController < ApplicationController
  before_action :authenticate_user!  # ユーザー認証が必要な場合
  
  def vote
    # 映画をidで検索
    @movie = Movie.find_by(id: params[:id])
    
    if @movie.nil?
      flash[:alert] = t('movies.not_found')  # 映画が見つからない場合のメッセージ
      redirect_to movies_path
      return
    end
    
    # ユーザーの総投票数を確認
    user_total_votes = Vote.where(user_id: current_user.id).count
    
    # ユーザーが特定の映画に投票しているか確認
    user_movie_votes = Vote.where(user_id: current_user.id, movie_id: @movie.id).count
    
    if user_total_votes >= 3
      flash[:alert] = t('votes.limit_reached')  # 投票制限を超えた場合のメッセージ
    elsif user_movie_votes > 0
      flash[:alert] = t('votes.already_voted')  # 特定の映画に既に投票している場合
    else
      # 投票を記録
      Vote.create(user_id: current_user.id, movie_id: @movie.id)
      
      # ユーザーの投票数を増加
      current_user.increment!(:vote_count)
      
      flash[:notice] = t('votes.success', movie_title: @movie.title, current_count: user_total_votes + 1)  # 投票成功時のメッセージ
    end
    
    # 映画のページにリダイレクト
    redirect_to movie_path(@movie.api_id)
  end
end
