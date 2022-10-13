Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :transport_models, only: %i[index new create show edit update show] do
    patch 'change_status', on: :member
  end
  resources :vehicles, only: %i[index new create update edit] do
    get 'search', on: :collection
  end
  resources :price_by_distances, only: %i[new create edit update destroy]
  resources :price_by_weights, only: %i[new create]
  resources :delivery_time_table, only: %i[new create]
end
