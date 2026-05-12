Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check
  post '/pokeScanner', to: 'poke_scanner#create'

  post '/login', to: 'log#login'

  resources :users, only: [:create], controller: 'user'

  resources :poke_scans, only: [:index, :destroy], controller: 'poke_scanner'

end
