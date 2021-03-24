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
  resources :home, only: [:index] do
    collection do
      post :index
    end
  end
  get 'about_us', to: 'home#about_us', as: :about_us
  get 'contact_us', to: 'home#contact_us', as: :contact_us
  # STORY ACTIONS
  resources :stories, only: [:show, :my_stories, :save_story, :forget_story] do
    member do
      post :save
      post :forget
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
      end

      member do
        get :review
        patch :review_update
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
        get :export_all
      end
    end
    resources :published_items, except: [:show] do
      member do
        post :display
        post :unpublish
      end

      collection do
        post :bulk_update
      end
    end
    resources :newsfeed, only: [:edit, :update] do
      member do
        post :remove
        post :publish
      end

      collection do
        get :queue
        get :activities
      end
    end
    resources :admin_settings, only: [:index, :update]
  end

  # redirect to home if route doesn't exist
  match "*path" => "home#index", via: [:get, :post]
end
