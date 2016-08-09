require 'sidekiq/web'

Minebuild::Application.routes.draw do
  root :to => 'schematics#index'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  ActiveAdmin.routes(self)

  devise_for :users

  namespace :plugin do
    resources :schematics, only: [:create, :download] do
      member do
        get :download
      end
    end
  end

  resources :schematics, only: [:index, :show] do
    member do
      get :download
    end
  end
end
