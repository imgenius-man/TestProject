Rails.application.routes.draw do
  devise_for :users


  # devise_for :users, controllers: {
  #   :sessions => "users/sessions",
  #   :registrations => "users/registrations" }

  resources :cases
  root 'cases#index'
end
