Rails.application.routes.draw do
  # Devise for developers
  devise_for :developers, controllers: {registrations: "developers/registrations"}

  # Root route
  root to: "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"

  # Resources
  resources :labels
  resources :developer_projects
  resources :notifications

  # Projects
  resources :projects do
    resources :tasks do
      member do
        patch "start"
        patch "finish"
      end
    end
    member do
      patch "cancel"
    end
  end

  # Tasks
  resources :tasks do
    member do
      post "add_label"
      delete "remove_label"
      post "add_developer"
      delete "remove_developer"
    end
  end
end
