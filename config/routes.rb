Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :news do
    resource :favorites, only: [:create, :destroy]
  end
  root to: 'news#index'
end
