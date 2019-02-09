Oak::Engine.routes.draw do
  resources :posts do
    collection do
      get '/category/:category', to: 'posts#category', as: :category
    end
  end

  namespace :admin do
    resources :posts do
      member do
        post :send_webmentions
      end
    end
    
    resources :post_assets
    resources :webmentions do
      collection do
        get :outgoing
      end
    end
  end
  
  namespace :micropub do
    post '/', to: 'micropub#micropub_post', as: :post
    get  '/', to: 'micropub#micropub_get',  as: :get
    post '/media', to: 'micropub#media',    as: :media
  end
  
  namespace :indieauth do
    post '/', to: 'indieauth#indieauth_post'
    get  '/', to: 'indieauth#indieauth_get'
    
    get '/authentication_request/:id', to: 'indieauth#show_authentication_request', as: :show_authentication_request
    post '/authorize_authentication_request/:id', to: 'indieauth#authorize_authentication_request', as: :authorize_authentication_request
    
    get  '/show_authorization_request/:id', to: 'indieauth#show_authorization_request', as: :show_authorization_request
    post '/authorize_authorization_request/:id', to: 'indieauth#authorize_authorization_request', as: :authorize_authorization_request
    
    post '/token', to: 'indieauth#request_token'
    get '/token',  to: 'indieauth#verify_token'
  end
  
  scope module: 'meta_weblog_api' do
    post '/xmlrpc.php', to: 'base#index', as: :xmlrpc
  end

  post '/webmention', to: 'webmentions#create', as: :incoming_webmention
  
  root to: 'posts#index'
end