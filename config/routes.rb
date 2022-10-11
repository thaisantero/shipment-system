Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :transport_models, only: [:index, :new, :create, :show, :edit, :update] do
    patch 'change_status', on: :member
  end
  resources :vehicles, only: [:index, :new, :create, :update, :edit] do
    get 'search', on: :collection
  end
end
