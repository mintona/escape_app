Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to:'welcome#index'

  get 'auth/google_oauth2', as: 'google_oauth2_login'
  # get '/auth/:provider/callback', to: 'users#create'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/profile', to: 'users#show'
end
