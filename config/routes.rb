require 'sidekiq/web'

Minebuild::Application.routes.draw do
  devise_for :users
  if Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  end

  root :to => 'schematics#index'

  resources :schematics, only: [:index, :show, :create] do
    member do
      get :download
    end
  end
end
