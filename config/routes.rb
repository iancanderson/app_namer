Rails.application.routes.draw do
  root to: "app_names#new"

  resources :app_names, only: [:create]

  get "app_name", to: "app_names#show"
end
