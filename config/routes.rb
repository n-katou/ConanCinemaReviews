Rails.application.routes.draw do
  get 'ranking/index'
  get 'pages/home'
  devise_for :users, controllers: {
    omniauth_callbacks: 'omniauth_callbacks'
  }

  root 'pages#home'
  resources :movies, only: [:index, :show, :destroy] do
    resources :reviews, only: [:create, :destroy] do
      resources :likes, only: [:create, :destroy]
    end
    member do
      post 'vote', to: 'votes#vote'
    end
  end
  
  post 'movies/fetch_movies', to: 'movies#fetch_movies', as: 'fetch_movies'
  get 'admin', to: 'admin#index'  # 管理者用トップページ
  post 'admin/reset_vote_count', to: 'admin#reset_vote_count'  # 投票数リセット
  get 'ranking', to: 'ranking#index'

end
