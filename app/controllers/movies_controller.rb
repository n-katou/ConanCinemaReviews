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
    if params[:looking_for].present?
      # 検索用の処理
      response = Tmdb::Search.movie(params[:looking_for])
    else
      # トレンド映画の取得
      response = Tmdb::Movie.popular
    end

    if response
      @movies = response['results']
    else
      @movies = []
    end
  end

  def fetch_movies
    # APIキーと日本語クエリをエンコード
    api_key = ENV['TMDB_API_KEY']
    query = URI.encode_www_form_component('名探偵コナン') # 日本語クエリをエンコード

    # エンコードされたURLに言語設定を追加
    url = "https://api.themoviedb.org/3/search/movie?api_key=#{api_key}&query=#{query}&language=ja"
    uri = URI(url)

    # APIからデータを取得
    response = Net::HTTP.get(uri)
    movies_data = JSON.parse(response)["results"]

    # データをDBに保存
    movies_data.each do |movie|
      Movie.create!(
        title: movie["title"],
        release_date: movie["release_date"],
        overview: movie["overview"],
        poster_path: movie["poster_path"]
      )
    end

    # 取得した映画データを表示
    @movies = Movie.all
  end
end
