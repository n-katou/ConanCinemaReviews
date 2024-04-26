class PagesController < ApplicationController
  def home
    @movies = Movie.order(release_date: :asc) 
  end
end
