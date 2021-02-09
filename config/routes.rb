Rails.application.routes.draw do
  # match 'stories/new' => 'stories#new', via: [:get, :post]
  # match 'stories/scrape' => 'stories#scrape', via: [:get, :post]
  # match 'stories/incomplete' => 'stories#incomplete', via: [:get, :post], as: :incomplete_stories
  # match 'stories/sequence' => 'stories#sequence', via: [:get, :post], as: :sequence_stories
  # match 'stories/:id/edit_seq' => 'stories#edit_seq', via: [:get, :post], as: :edit_seq
  # match 'stories/:id/publish_now' => 'stories#pub_now', via: [:get, :post], as: :pub_now
  # match 'stories/story_proof/:id' => 'stories#story_proof', via: [:get, :post], as: :story_proof
  # match '/my_stories' => 'usersavedstories#my_stories', via: [:get, :post]
  # match '/usersavedstories/:id' => 'usersavedstories#destroy', via: [:delete], as: :destroy_usersavedstories
  # # match '/' => 'visitors#index', via: [:get, :post]

  # post '/visitors/save_story/:id', to: 'visitors#save_story', as: :save_story
  # post '/visitors/forget_story/:id', to: 'visitors#forget_story', as: :forget_story

  # match '/visitors/refresh_timer' => 'visitors#refresh_timer', via: [:get]
  # match '/reports/export_all' => 'reports#export_all', via: [:get, :post]
  # match '/reports/export_stories' => 'reports#export_stories', via: [:get, :post]
  # match '/index' => 'reports_controller#index', via: [:get, :post]
  # match '/reports/export_allstories' => 'reports#export_allstories', via: [:get, :post]
  # match '/reports/export_stories' => 'reports#export_stories', via: [:get, :post]
  # match '/reports/export_images' => 'reports#export_images', via: [:get, :post]
  # match '/reports/export_mediaowners' => 'reports#export_mediaowners', via: [:get, :post]
  # match '/reports/export_usersaved' => 'reports#export_usersaved', via: [:get, :post]
  # match '/reports/export_userlisting' => 'reports#export_userlisting', via: [:get, :post]
  # match '/reports/export_actionlisting' => 'reports#export_actionlisting', via: [:get, :post]
  # match '/reports/export_outboundclick' => 'reports#export_outboundclick', via: [:get, :post]
  # # match '/reports/user_actions' => 'reports#user_actions', via: [:get, :post]

  # #get '/click', to: 'outbound_clicks#show', as: :outbound_click

  # resources :stories #original from generate
  # resources :reports
  # resources :urls
  # resources :images
  # resources :mediaowners
  # resources :locations
  # resources :place_categories
  # resources :story_categories
  # resources :codes

  # # root to: 'visitors#index', via: [:get, :post]  #added by gg
  # get 'products/:id', to: 'products#show', :as => :products


  # ROOT
  root 'home#index'
  # DEVISE STUFF
  devise_for :users, controllers: {
    sessions: "users/sessions",
    passwords: "users/passwords",
    registrations: "users/registrations"
  }
  # UPDATE USER
  resources :users, only: [:edit, :update]
  # HOME CONTROLLER
  resources :home, only: [:index]
  get 'about_us', to: 'home#about_us', as: :about_us
  get 'contact_us', to: 'home#contact_us', as: :contact_us
  # STORY ACTIONS
  resources :stories, only: [:show, :my_stories, :save_story, :forget_story] do
    member do
      post :save_story
      post :forget_story
    end
  end
  # MY STORIES
  get 'my_stories', to: 'stories#my_stories'
  # ADMIN ROUTES
  namespace :admin do
    resources :stories do
      collection do
        get :initialize_scraper
        post :scrape
        post :new
        get :incomplete
        get :sequence
        post :sequence
        get :edit_seq
        post :edit_seq
        get :pub_now
        post :pub_now
        get :story_proof
        post :story_proof
      end
    end
    resources :urls, except: [:show]
    resources :images, except: [:show]
    resources :codes, except: [:show]
    resources :locations, except: [:show]
    resources :place_categories, except: [:show]
    resources :story_categories, except: [:show]
  end
end
