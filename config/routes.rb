Rails.application.routes.draw do
  root 'reciprocals#index', as: 'home'

  get 'about' => 'pages#about', as: 'about'
  get 'help' => 'pages#help', as: 'help'

  resources :reciprocals
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
