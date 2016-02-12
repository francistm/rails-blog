Rails.application.routes.draw do
  namespace :admin do
    get '', to: 'dashboard#index', as: :dashboard

    get 'settings', to: 'settings#index', as: :settings
    put 'settings', to: 'settings#update'

    resources :posts
    resources :uploads
    resources :jekyll_imports, only: [:new, :create]
  end

  namespace :front, path: '' do
    resources :posts, path: 'entries', param: :slug, only: :show do
      get 'archive', action: :index, on: :collection
    end
  end

  root to: 'front/site#index'
  devise_for :admins, path: 'admin', module: :admin
end
