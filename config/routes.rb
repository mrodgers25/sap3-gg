Rails.application.routes.draw do
  resources :codes

  resources :media_infos

  match 'stories/new' => 'stories#new', via: [:get, :post]
  match 'stories/scrape' => 'stories#scrape', via: [:get, :post]
  match 'stories/my_stories' => 'stories#my_stories', via: [:get, :post]
  match '/' => 'visitors#index', via: [:get, :post]

  post '/visitors/save_story/:id', to: 'visitors#save_story', as: :save_story
  post '/visitors/forget_story/:id', to: 'visitors#forget_story', as: :forget_story

  match '/visitors/refresh_timer' => 'visitors#refresh_timer', via: [:get]
  match '/reports/export_stories_users' => 'reports#export_stories_users', via: [:get, :post]
  match '/reports/export_stories' => 'reports#export_stories', via: [:get, :post]

  resources :stories #original from generate
  resources :urls
  resources :images
  # resources :visitors

  root to: 'visitors#index', via: [:get, :post]  #added by gg
  get 'products/:id', to: 'products#show', :as => :products
  devise_for :users
  resources :users

end
