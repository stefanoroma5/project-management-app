Rails.application.routes.draw do
  devise_for :developers, controllers: {registrations: "developers/registrations"}

  resources :labels
  resources :projects do
    resources :tasks
  end
  resources :developer_projects
  resources :notifications

  # config/routes.rb
  resources :projects do
    member do
      patch "cancel"
    end
  end

  root to: "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
