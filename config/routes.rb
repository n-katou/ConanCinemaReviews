Rails.application.routes.draw do
  get 'pages/home'
  # root to: 'pages#home'
  
  devise_for :users

  root 'movies#index'
  resources :movies, only: [:index, :show, :destroy] 
  post 'movies/fetch_movies', to: 'movies#fetch_movies', as: 'fetch_movies'
  get 'movies/searcb', to: 'movies#search'
end
