Rails.application.routes.draw do
  post 'api/sign_in'

  post 'api/register'
  
  get 'api/message'

  post 'api/message'

  post 'api/gcm'

  post 'api/add_link'

  post 'api/update_link'

  post 'api/getlinks/:id/:phoneno' => "api#getlinks"

  post 'api/delete_link/:id/:phoneno' => "api#delete_link"

  post 'api/contacts'

  resources :links
  namespace :admin do
    resources :users
    root to: "users#index"
  end
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
