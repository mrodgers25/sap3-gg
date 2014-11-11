Rails.application.routes.draw do
  resources :codes

  resources :media_infos

  match 'stories/new' => 'stories#new', via: [:get, :post]  #added by gg
  match 'stories/scrape' => 'stories#scrape', via: [:get, :post]  #added by gg
  match '/' => 'visitors#index', via: [:get, :post]  #added by gg
  match '/visitors/refresh_timer' => 'visitors#refresh_timer', via: [:get]  #added by gg
  match '/reports/csv_export' => 'reports#csv_export', via: [:get, :post]  #added by gg

  resources :stories #original from generate
  resources :urls
  resources :images
  # resources :visitors

  root to: 'visitors#index', via: [:get, :post]  #added by gg
  get 'products/:id', to: 'products#show', :as => :products
  devise_for :users
  resources :users

end