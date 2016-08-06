require 'sidekiq/web'

Minebuild::Application.routes.draw do
  root :to => 'schematics#index'

  if Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  end

  ActiveAdmin.routes(self)

  devise_for :users

  resources :schematics, only: [:index, :show, :create] do
    member do
      get :download
    end
  end
end
