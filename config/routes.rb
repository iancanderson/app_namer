Rails.application.routes.draw do
  root to: "app_names#new"

  resources :app_names, only: [:create, :show]
end
