Rails.application.routes.draw do
  namespace :admin do
    resources :relation_types
    resources :products do
      resources :relations
      member do
        get :related
      end
    end
  end
end
