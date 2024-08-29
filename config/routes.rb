# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|zh-TW/ do
    resources :users, only: %i[new create edit update]
    namespace :admin do
      resources :users, only: %i[index edit update destroy]
    end
    resources :tasks, except: %i[index] do
      collection do
        get :personal
        post :sort
      end
      member do
        patch :update_importance
      end
    end
    resources :group_tasks, only: %i[index]

    resources :notifications, only: %i[index] do
      member do
        patch :mark_as_read
      end
    end

    resources :groups, except: %i[show] do
      delete 'remove_user', on: :member
    end

    resources :reports, only: [] do
      collection do
        get :tag_usage
      end
    end

    root 'tasks#personal'

    get 'signup', to: 'users#new'
    post 'signup', to: 'users#create'
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    get '/profile/edit', to: 'users#edit_profile', as: :edit_profile
    patch '/profile', to: 'users#update_profile', as: :update_profile
  end
  get '', to: redirect('/%<locale>s'), defaults: { locale: I18n.default_locale }
end
