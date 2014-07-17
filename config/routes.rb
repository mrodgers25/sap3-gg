Rails.application.routes.draw do
  resources :media_infos

  resources :stories

  resources :urls

  root to: 'visitors#index'
  get 'products/:id', to: 'products#show', :as => :products
  devise_for :users
  resources :users
end
