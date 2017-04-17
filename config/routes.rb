Rails.application.routes.draw do
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  root "static_pages#home"
  resources :users, only: [:show]
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
end
