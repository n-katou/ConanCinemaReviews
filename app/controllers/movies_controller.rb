class MoviesController < ApplicationController
  require 'themoviedb-api'
  require 'net/http'
  require 'json'
  require 'uri'


  Tmdb::Api.key("#{ENV['TMDB_API_KEY']}")
  Tmdb::Api.language("ja")


  def show
    @movie = Tmdb::Movie.detail(params[:id])
  end

  def index
    @movies = Movie.order(release_date: :asc) 
  end

  def destroy
    @movie = Movie.find(params[:id])
    if @movie.destroy
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove("movie_#{@movie.id}")  # Turboで対象要素を削除
        end
        format.html do
          flash[:notice] = '映画を削除しました。'
          redirect_to movies_path
        end
      end
    else
      flash[:alert] = '映画の削除に失敗しました。'
      redirect_back fallback_location: root_path
    end
  end

  def fetch_movies
    # APIキーと日本語クエリ
    api_key = ENV['TMDB_API_KEY']
    query = URI.encode_www_form_component('名探偵コナン')
    language = 'ja'
  
    # ページ数を設定して全ページから取得
    total_pages = 1  # 初期値
    page = 1
    movies_list = []  # 全部の映画データを格納
  
    while page <= total_pages
      # ページごとのURL
      url = "https://api.themoviedb.org/3/search/movie?api_key=#{api_key}&query=#{query}&language=#{language}&page=#{page}"
      uri = URI.parse(url)
  
      # APIからデータを取得
      response = Net::HTTP.get_response(uri)
      raise 'Failed to get movie data' unless response.is_a?(Net::HTTPSuccess)
  
      # レスポンスからデータを抽出
      data = JSON.parse(response.body)
      movies_list.concat(data["results"])  # 取得した映画データをリストに追加
  
      # 全ページ数を更新
      total_pages = data["total_pages"]
  
      # 次のページに進む
      page += 1
    end
  
    # データベースに保存
    movies_list.each do |movie|
      next if Movie.exists?(api_id: movie["id"])  # 重複チェック
  
      # 映画情報を保存
      Movie.create!(
        api_id: movie["id"],
        title: movie["title"],
        release_date: movie["release_date"],
        overview: movie["overview"],
        poster_path: movie["poster_path"]
      )
    end
  end
end
