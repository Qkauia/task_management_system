Rails.application.routes.draw do
  scope "(:locale)", locale: /en|zh-TW/ do
    resources :tasks
    resources :users, only: [:new, :create, :edit, :update]

    root "tasks#index"

    get 'signup', to: 'users#new'
    post 'signup', to: 'users#create'
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
  end
  get '', to: redirect("/%{locale}"), defaults: { locale: I18n.default_locale }
end
