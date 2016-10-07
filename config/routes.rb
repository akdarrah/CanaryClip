require 'sidekiq/web'

CanaryClip::Application.routes.draw do
  root :to => 'marketing#index'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  ActiveAdmin.routes(self)

  devise_for :users

  namespace :user do
    resources :character_claims, only: [:index, :show, :new, :create]

    resources :characters, only: [] do
      member do
        post :switch
      end
    end

    resources :servers, only: [:index, :show, :new, :create, :edit, :update] do
      collection do
        get :download
      end
    end
  end

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

  get 'quick_start', to: "documentation#quick_start"
  get 'server_setup', to: "documentation#server_setup"
  get 'character_claims', to: "documentation#character_claims"

  resources :blocks, only: [:show]
  resources :characters, only: [:show]
  resources :servers, only: [:show]

  get '/schematics', to: redirect('/builds')
  get '/schematics/:id', to: redirect('/builds/%{id}')

  resources :schematics, :path => :builds, only: [:index, :show, :update, :destroy] do
    resources :favorites, only: [:create, :destroy]

    member do
      get :download
    end
  end
end
