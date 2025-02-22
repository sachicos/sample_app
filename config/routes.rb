Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  # root 'static_pages#home'
  root 'static_pages#home'
  # get 'static_pages/home'

  # get 'static_pages/help'
  get  '/help',    to: 'static_pages#help'
  # => help_path -> '/help' ←これが使えるようになる！
  # => help_url  -> 'https://www.example.com/help'

  # get 'static_pages/about'
  get  '/about',   to: 'static_pages#about'

  # get 'static_pages/contact'
  get  '/contact', to: 'static_pages#contact'
  
  get  '/signup', to: 'users#new'
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :users
  
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
