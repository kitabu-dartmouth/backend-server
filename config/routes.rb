Rails.application.routes.draw do
  post 'api/sign_in'

  post 'api/register'

  post 'api/add_link'

  get 'api/update_link'

  get 'api/delete_link'

  resources :links
  namespace :admin do
    resources :users
    root to: "users#index"
  end
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
