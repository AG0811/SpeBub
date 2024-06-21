Rails.application.routes.draw do
  resources :news do
    resource :favorites, only: [:create, :destroy]
  end
  root to: 'news#index'
end
