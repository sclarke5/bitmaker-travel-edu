Rails.application.routes.draw do

  root 'months#index'

  resource :user, only: [:new, :create]
  resource :session, only: %i[new create destroy]

  resources :months, only: %i[index] do
    resources :countries, only: %i[index]
  end

  resources :countries, only: %i[index] do
    resources :cities, only: %i[index]
  end

  resources :cities, only: %i[index] do
    resources :hotels, only: %i[index show]
  end

  resources :favourites, only: %i[index destroy]
  resources :hotels, only: %i[show] do
    resources :favourites, only: %i[new create]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
