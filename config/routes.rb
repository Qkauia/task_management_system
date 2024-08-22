Rails.application.routes.draw do
  scope "(:locale)", locale: /en|zh-TW/ do
    resources :users, only: [:new, :create, :edit, :update]
    namespace :admin do
      resources :users, only: [:index, :edit, :update, :destroy]
    end
    resources :tasks

    resources :notifications, only: [:index] do
      member do
        patch :mark_as_read
      end
    end
    
    resources :groups, except: [:show] do
      delete 'remove_user', on: :member
    end
    
    root "tasks#index"
    
    get 'signup', to: 'users#new'
    post 'signup', to: 'users#create'
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    get '/profile/edit', to: 'users#edit_profile', as: :edit_profile
    patch '/profile', to: 'users#update_profile', as: :update_profile
  end
  get '', to: redirect("/%{locale}"), defaults: { locale: I18n.default_locale }
end
