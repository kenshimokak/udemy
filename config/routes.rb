Rails.application.routes.draw do
  resources :comments
  resources :users
  resources :articles
  resources :categories
  resources :users, only: [:show]
  resources :friendships
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#home'

  get 'about', to: 'pages#about'

  get 'signup', to: 'users#new'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'my_friends', to: 'users#my_friends'
  get 'search_friends', to: "users#search"
  post 'add_friend', to: 'users#add_friend'

end
