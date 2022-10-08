Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :transport_models, only: [:index, :new, :create, :show] do
    patch 'change_status', on: :member
  end
end
