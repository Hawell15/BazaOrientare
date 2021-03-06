Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  resources :results
  resources :groups
  resources :competitions
  resources :runners
  resources :clubs
  resources :categories
  get 'home/wredata'
  get 'home/wre_id'
  get 'home/wre_results_men'
  get 'home/wre_results_women'
  get 'home/wredata'



  root to: 'home#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
