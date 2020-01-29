Rails.application.routes.draw do
  root 'games#index'

  resources :sessions,        only: [:new, :create, :destroy]
  resources :games,           only: [:index, :new, :create, :edit, :update]
  resources :friends,         only: [:index, :create, :destroy]
  resources :friend_requests, only: [:new, :create, :destroy]
end
