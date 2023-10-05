Rails.application.routes.draw do
  devise_for :developers, :controllers => { registrations: 'developers/registrations' }

  resources :labels
  resources :tasks
  resources :projects

  root to: "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
