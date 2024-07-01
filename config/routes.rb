Rails.application.routes.draw do
  resources :news do
    resource :favorites, only: [:create, :destroy]
    resources :comments, only: :create

    collection do
      get 'search'
    end

  end
  root to: 'news#index'

  match '/', to: 'news#index', via: :options
end