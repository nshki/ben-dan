Rails.application.routes.draw do
  root 'games#index'

  # Self management.
  resource  :account,  only: [:edit, :update]
  resources :sessions, only: [:new, :create, :destroy]

  # Playing.
  resources :games,           only: [:index, :create, :edit, :update]
  resources :friends,         only: [:index, :create, :destroy]
  resources :friend_requests, only: [:new, :create, :destroy]
end
