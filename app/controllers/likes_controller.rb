class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review

  def create
    @like = @review.likes.create(user: current_user)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to movie_path(@review.movie.id) }
    end
  end

  def destroy
    @like = @review.likes.find_by(user: current_user)
    @like&.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to movie_path(@review.movie.id) }
    end
  end

  private

  def set_review
    @review = Review.find(params[:review_id])
    @movie = @review.movie  
  end
end
