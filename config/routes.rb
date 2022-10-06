Rails.application.routes.draw do
  root 'home#index'
  resources :transport_models, only: [:index]
end
