Oak::Engine.routes.draw do
  resources :posts

  namespace :admin do
    resources :posts
  end
  
  namespace :micropub do
    post '/', to: 'micropub#micropub_post'
    get  '/', to: 'micropub#micropub_get'
  end
  
  namespace :indieauth do
    post '/', to: 'indieauth#indieauth_post'
    get  '/', to: 'indieauth#indieauth_get'
    
    get '/authentication_request', to: 'indieauth#show_authentication_request', as: :show_authentication_request
    post '/authorize_authentication_request', to: 'indieauth#authorize_authentication_request', as: :authorize_authentication_request
    
    get  '/show_authorization_request', to: 'indieauth#show_authorization_request', as: :show_authorization_request
    post '/authorize_authorization_request', to: 'indieauth#authorize_authorization_request', as: :authorize_authorization_request
    
    post '/token', to: 'indieauth#request_token'
    get '/token',  to: 'indieauth#verify_token'
    
  end
  
  root to: 'posts#index'
end