require 'sidekiq/web'

Minebuild::Application.routes.draw do
  if Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :schematics, only: [:create] do
    member do
      get :download
    end
  end
end
