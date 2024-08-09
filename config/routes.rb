Rails.application.routes.draw do
  scope "(:locale)", locale: /en|zh-TW/ do
    devise_for :users
    resources :tasks
    root "tasks#index"
  end
  get '', to: redirect("/%{locale}"), defaults: { locale: I18n.default_locale }
end
