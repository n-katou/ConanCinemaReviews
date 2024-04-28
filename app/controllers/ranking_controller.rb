class RankingController < ApplicationController
  def index
    @movies = Movie
                       .left_joins(:votes)  # 映画と投票を左外部結合
                       .group('movies.id')  # 映画のIDでグループ化
                       .order('COUNT(votes.id) DESC')  # 投票数の多い順に並び替え
  end

  def reviews_ranking
    @movies = Movie
                      .left_joins(:reviews)  # 映画とレビューを左外部結合
                      .group('movies.id')  # 映画のIDでグループ化
                      .order('COUNT(reviews.id) DESC')  # レビュー数の多い順に並び替え
  end
end
