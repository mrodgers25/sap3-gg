Rails.application.routes.draw do
  # ROOT
  root 'home#index'
  # DEVISE STUFF
  devise_for :users, controllers: {
    sessions: "users/sessions",
    passwords: "users/passwords",
    registrations: "users/registrations",
    confirmations: "users/confirmations"
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
        get :incomplete
      end

      member do
        post :publish
        get :review
        patch :review_update
        post :approve
        patch :update_state
      end
    end
    resources :urls, except: [:show]
    resources :images, except: [:show]
    resources :codes, except: [:show]
    resources :locations, except: [:show]
    resources :place_categories, except: [:show]
    resources :story_categories, except: [:show]
    resources :media_owners, except: [:show]
    resources :users, except: [:show]
    resources :reports, only: [:index] do
      collection do
        get :export_allstories
        get :export_stories
        get :export_images
        get :export_mediaowners
        get :export_usersaved
        get :export_userlisting
        get :export_actionlisting
        get :export_outboundclick
        get :export_all
      end
    end
    resources :published_items, except: [:show] do
      member do
        post :publish
        post :unpublish
      end
    end
  end

  # redirect to home if route doesn't exist
  match "*path" => "home#index", via: [:get, :post] unless Rails.env.development?
end
