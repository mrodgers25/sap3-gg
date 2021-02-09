Rails.application.routes.draw do
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
        get :sequencer
      end

      member do
        get :edit_sequence
        patch :update_sequence
        post :publish
      end
    end
    resources :urls, except: [:show]
    resources :images, except: [:show]
    resources :codes, except: [:show]
    resources :locations, except: [:show]
    resources :place_categories, except: [:show]
    resources :story_categories, except: [:show]
    resources :mediaowners, except: [:show]
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
  end
end
