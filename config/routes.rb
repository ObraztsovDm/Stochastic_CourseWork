Rails.application.routes.draw do
  root 'reciprocals#index', as: 'home'

  get 'about' => 'pages#about', as: 'about'
  get 'help' => 'pages#help', as: 'help'

  resources :reciprocals
end
