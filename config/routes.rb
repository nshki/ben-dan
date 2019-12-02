Rails.application.routes.draw do
  root 'games#index'

  resources :sessions, only: [:new, :create, :destroy]
  resources :games,    only: [:index, :new, :create, :edit, :update]
end
