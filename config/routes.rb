Rails.application.routes.draw do
  get "admin", to: "admin#spellings"

  root to: "app_names#new"

  resources :app_names, only: [:create]
  resources :charges


  get "domain_availability", to: "domain_availabilities#show"
  get "app_name", to: "app_names#show"
end
