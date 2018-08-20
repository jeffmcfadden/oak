Oak::Engine.routes.draw do
  resources :posts

  namespace :admin do
    resources :posts
  end

  root to: 'posts#index'
end