Minebuild::Application.routes.draw do
  resources :schematics, only: [:create] do
    member do
      get :download
    end
  end
end
