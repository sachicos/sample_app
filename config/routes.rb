Rails.application.routes.draw do
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
  
  resources :users
end
