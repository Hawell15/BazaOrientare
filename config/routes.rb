Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  resources :results
  resources :groups
  resources :competitions
  resources :runners
  resources :clubs
  resources :categories

  root to: 'home#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
