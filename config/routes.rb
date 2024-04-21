Rails.application.routes.draw do
  get 'pages/home'
  # root to: 'pages#home'
  
  devise_for :users

  root 'movies#index'
  resources :movies, only: [:index, :show, :destroy] do
    member do
      post 'vote', to: 'votes#vote'
    end
    resources :reviews, only: [:new, :create]
  end
  post 'movies/fetch_movies', to: 'movies#fetch_movies', as: 'fetch_movies'
  get 'movies/searcb', to: 'movies#search'

end
