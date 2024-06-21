Rails.application.routes.draw do
  resources :news do
    resource :favorites, only: [:create, :destroy]
    resources :comments, only: :create
  end
  root to: 'news#index'
end
