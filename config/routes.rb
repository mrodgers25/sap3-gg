Rails.application.routes.draw do
  resources :media_infos

  match 'stories/new/url_show' => 'stories#url_show', via: [:get, :post]  #added by gg
  match 'stories/new' => 'stories#new', via: [:get, :post]  #added by gg
  match 'stories/scrape' => 'stories#scrape', via: [:get, :post]  #added by gg
  # match 'stories/scrape' => 'stories#scrape', via: [:get, :post]  #added by gg

  resources :stories #original from generate

  resources :urls

  root to: 'visitors#index'
  get 'products/:id', to: 'products#show', :as => :products
  devise_for :users
  resources :users

end