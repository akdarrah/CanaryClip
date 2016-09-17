require 'sidekiq/web'

Minebuild::Application.routes.draw do
  root :to => 'schematics#index'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  ActiveAdmin.routes(self)

  devise_for :users

  namespace :plugin do
    resources :character_claims, only: [] do
      member do
        post :claim
      end
    end
    resources :schematics, only: [:create, :download] do
      member do
        get :download
      end
    end
  end

  resources :blocks, only: [:show]
  resources :characters, only: [:show]
  resources :servers, only: [:show]

  resources :character_claims, only: [:index, :show, :new, :create]
  resources :schematics, only: [:index, :show, :update] do
    resources :favorites, only: [:create, :destroy]

    member do
      get :download
    end
  end
end
