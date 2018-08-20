Oak::Engine.routes.draw do
  resources :posts

  namespace :admin do
    resources :posts
  end
  
  namespace :micropub do
    post '/', to: 'micropub#micropub_post'
    get  '/', to: 'micropub#micropub_get'
  end

  root to: 'posts#index'
end