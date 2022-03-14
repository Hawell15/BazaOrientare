Rails.application.routes.draw do
  resources :results
  resources :groups
  resources :competitions
  resources :runners
  resources :clubs
  resources :categories
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
