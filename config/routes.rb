Rails.application.routes.draw do
  namespace :admin do
    get '', to: 'dashboard#index', as: :dashboard

    get 'settings', to: 'settings#index', as: :settings
    put 'settings', to: 'settings#update'

    resources :posts
    resources :uploads
    resources :jekyll_imports, only: [:new, :create]
  end

  namespace :front do
    resources :posts, only: [:show, :index]
  end

  root to: 'front/site#index'
  devise_for :admins, path: 'admin', module: :admin
end
