Rails.application.routes.draw do
  # get 'tracks/index'
  get "/", to: "tracks#index", as: "root"
  # get 'users/:id/tracks' => 'users#tracks', :as => :user_tracks
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tracks
  #added this line so I can automatically create all the routes for the tracks controller
end
