Rails.application.routes.draw do
  resources :keywords  do

    get 'scrap_html', on: :member
  end

  resources :jobs, only: [:create]


  get 'home/index'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: 'keywords#index' # replace 'home#index' with your desired root controller and action
end
