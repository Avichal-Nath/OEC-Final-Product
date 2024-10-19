Rails.application.routes.draw do
  # Complaints routes
  get 'complaints/new'
  get 'complaints/create'
  
  # Users routes
  get 'users/show'
  get 'users/edit'
  get 'users/update'
  
  # Devise routes for client users with custom controllers
  devise_for :users, path: 'users', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Admin namespace routes
  namespace :admin do
    devise_for :admins, controllers: {
      sessions: 'admin/sessions'
    }

    resources :products do
      member do
        delete :remove_image
      end
    end
    
    resources :complaints, only: [:index]  # For admin to view complaints
    resources :orders
    resources :users
  end

  # Client-side routes
  namespace :clients do
    root 'home#index'

    # Products routes (including men's wear)
    resources :products, only: [:index, :show] do
      collection do
        get 'mens_wear', to: 'products#men', as: :mens_wear
        get 'womens_wear', to: 'products#women', as: :womens_wear
        get 'search', to: 'products#search', as: :search
      end
    end

    resources :complaints, only: [:new, :create]
    get 'complaints/success', to: 'complaints#success', as: 'complaints_success'

    # Cart routes
    resource :cart, only: [:show] do
      post 'add_item/:product_id', to: 'carts#add_item', as: 'add_item_to_cart'
      delete 'remove_item/:id', to: 'carts#remove_item', as: 'remove_item'
      patch 'update_quantity/:id', to: 'carts#update_quantity', as: 'update_quantity'
      post 'confirm', to: 'carts#confirm', as: 'confirm'
    end

    # Orders routes
    resources :orders, only: [:new, :create, :show]  # Ensure orders routes are defined
    resources :users, only: [:new, :create, :edit, :update]

    # Mock payment route should be within the clients namespace
    post 'mock_payments', to: 'mock_payments#create', as: 'mock_payments'
  end

  # General product routes
  resources :products, only: [:index, :show, :create, :update, :destroy]

  # Root route set to client-side home index
  root "clients/home#index"
end
