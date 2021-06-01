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
  resources :sessions, only: :toggle_sidebar_state do
    collection do
      post :toggle_sidebar_state
    end
  end
  # MY STORIES
  get 'my_stories', to: 'stories#my_stories'
  # ADMIN ROUTES
  namespace :admin do
    resources :initialize_scraper, only: [:index] do
      collection do
        get :scrape
      end
    end
    resources :stories, only: [:index, :show, :destroy] do
      member do
        get :review
        patch :review_update
        patch :update_state
      end

      collection do
        get :bulk_index
        post :bulk_update
      end
    end
    resources :media_stories, except: [:index, :destroy] do
      collection do
        get :scrape
      end
    end
    resources :video_stories, except: [:index, :destroy] do
      collection do
        get :scrape
      end
    end
    resources :custom_stories, except: [:index, :destroy] do
      member do
        post :destroy_internal_image
      end
    end
    resources :urls, except: [:show]
    resources :images, except: [:show]
    resources :codes, except: [:show]
    resources :locations, except: [:show]
    resources :place_categories, except: [:show]
    resources :story_categories, except: [:show]
    resources :media_owners, except: [:show]
    resources :users, except: [:show] do
      collection do
        post :bulk_update
      end
    end
    resources :reports, only: [:index] do
      collection do
        get :export_allstories
        get :export_stories
        get :export_images
        get :export_mediaowners
        get :export_usersaved
        get :export_userlisting
        get :export_all
        get :export_newsfeed_activities
      end
    end
    resources :published_items, except: [:show] do
      member do
        post :display
        post :unpublish
        post :add_to_queue
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
  match "*path" => "home#index", via: [:get, :post] if Rails.env.production?
end
