Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check
  post '/pokeScanner', to: 'poke_scanner#create'

end
