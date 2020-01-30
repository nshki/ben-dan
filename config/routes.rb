Rails.application.routes.draw do
  root 'games#index'

  resources :sessions,        only: [:new, :create, :destroy]
  resources :games,           only: [:index, :create, :edit, :update]
  resources :friends,         only: [:index, :create, :destroy]
  resources :friend_requests, only: [:new, :create, :destroy]
end
