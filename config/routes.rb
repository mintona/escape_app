Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to:'welcome#index'

  get 'auth/google_oauth2', as: 'google_oauth2_login'
  get '/auth/google_oauth2/callback', to: 'sessions#create'

  get '/logout', to: 'sessions#destroy'

  get '/about', to: 'about#show'
  get '/profile', to: 'users#show'

  get '/search', to: 'search#new'
  post '/search', to: 'search#create'

  get '/trip/new', to: "trip#new"
  post '/trip/create', to: "trip#create"

  namespace :search do
    get '/climbs/new', to: 'climbs#new'
  end

  resources :trips, only: [:show]
end
