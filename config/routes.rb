Rails.application.routes.draw do
  namespace :admins do
    get '', to: 'dashboard#index', as: :dashboard

    get 'settings', to: 'settings#index', as: :settings
    put 'settings', to: 'settings#update'

    resources :links, except: :show
    resources :posts, except: :show
    resources :uploads, except: [:edit, :update]
    resources :jekyll_imports, only: [:new, :create]
  end

  devise_for :admins, path: 'admins', module: :admins

  namespace :guests, path: '' do
    get 'feed', to: 'site#feed', defaults: { format: 'xml' }

    resources :links, only: :index
    resources :posts, path: 'entries', param: :slug, only: :show do
      get 'archive', action: :index, on: :collection
    end
  end

  root to: 'guests/site#index'
end
