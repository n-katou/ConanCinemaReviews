class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie
  before_action :set_review, only: [:destroy] 

  def create
    @review = @movie.reviews.build(review_params)
    @review.user = current_user
  
    if @review.save
      flash[:notice] = "レビューが投稿されました。"
      redirect_to movie_path(@movie.id)  # ここでapi_idを使用
    else
      Rails.logger.error("Failed to save review: #{@review.errors.full_messages.join(', ')}")  # エラーログを追加
      flash[:alert] = "レビューの投稿に失敗しました。"
      redirect_to movie_path(@movie.api_id)  # 映画ページへリダイレクト
    end
  end

  def destroy
    if @review.destroy
      flash[:notice] = "レビューが削除されました。"
    else
      flash[:alert] = "レビューの削除に失敗しました。"
    end
    redirect_to movie_path(@movie.id)
  end

  private

  def review_params
    params.require(:review).permit(:content)
  end

  def set_movie
    movie_id = params[:movie_id]
    @movie = Movie.find_by(id: movie_id)
    unless @movie
      flash[:alert] = "映画が見つかりませんでした。"
      redirect_to movies_path 
    end
  end

  def set_review  
    @review = @movie.reviews.find(params[:id])
    if @review.nil?
      flash[:alert] = "レビューが見つかりませんでした。"
      redirect_to movie_path(@movie.id)
    end
  end
end
