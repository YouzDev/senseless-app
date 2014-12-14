Twitter::Application.routes.draw do

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy]

  root 'pages#home'
  match '/home', to: 'pages#home', via: 'get'
  match '/about', to: 'pages#about', via: 'get'
  match '/help', to: 'pages#help', via: 'get'
  match '/signup', to: 'users#new', via: 'get'
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match '/contact', to: 'pages#contact', via: 'get'
  match '/search', to: 'search#search', via: 'get'
  # match '/settings', to: 'users#edit', via: 'get'
end
